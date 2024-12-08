import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  Map<String, String>? prayerTimes;
  String? location; // To store "City, State"
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPrayerTimes();
  }

  Future<void> _fetchPrayerTimes() async {
    try {
      // Get the user's location
      Position position = await _determinePosition();

      // Fetch city and state using reverse geocoding
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final Placemark place = placemarks[0];
      location = "${place.locality}, ${place.administrativeArea}";

      // Fetch prayer times from the API
      final response = await http.get(
        Uri.parse(
          'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=2',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Validate and extract prayer times
        if (data['data'] != null && data['data']['timings'] != null) {
          final timings = Map<String, String>.from(data['data']['timings']);

          // Convert timings to the desired format
          final formattedTimings = timings.map((key, value) {
            try {
              final time = DateFormat("HH:mm").parse(value); // Parse 24-hour time
              final formattedTime = DateFormat('hh:mm a').format(time); // Format to 12-hour time
              return MapEntry(key, formattedTime);
            } catch (e) {
              return MapEntry(key, value); // Fallback to original if parsing fails
            }
          });

          if (mounted) {
            setState(() {
              prayerTimes = formattedTimings;
              isLoading = false;
            });
          }
        } else {
          throw Exception('Unexpected API response structure.');
        }
      } else {
        throw Exception('Failed to fetch prayer times. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them in your settings.');
    }

    // Request and check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied. Please allow access to your location.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // Helper method to filter the prayer times
  Map<String, String> _filterPrayerTimes(Map<String, String> timings) {
    const keysToShow = {'Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'};
    return Map.fromEntries(
      timings.entries.where((entry) => keysToShow.contains(entry.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : prayerTimes == null
                  ? const Center(
                      child: Text(
                        'No prayer times available.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        if (location != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              'Location: $location',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ..._filterPrayerTimes(prayerTimes!).entries.map((entry) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                entry.key,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                entry.value,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
    );
  }
}
