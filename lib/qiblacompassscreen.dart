import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

class QiblaCompassScreen extends StatefulWidget {
  const QiblaCompassScreen({super.key});

  @override
  QiblaCompassScreenState createState() => QiblaCompassScreenState();
}

class QiblaCompassScreenState extends State<QiblaCompassScreen> {
  double? qiblaDirection;
  String errorMessage = '';
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _calculateQiblaDirection();
  }

  Future<void> _calculateQiblaDirection() async {
    try {
      Position position = await _determinePosition();
      currentPosition = position;
      const kaabaLatitude = 21.4225;
      const kaabaLongitude = 39.8262;

      final userLatitude = position.latitude * pi / 180.0;
      final userLongitude = position.longitude * pi / 180.0;
      final deltaLongitude = (kaabaLongitude - position.longitude) * pi / 180.0;

      final y = sin(deltaLongitude) * cos(kaabaLatitude * pi / 180.0);
      final x = cos(userLatitude) * sin(kaabaLatitude * pi / 180.0) -
          sin(userLatitude) *
              cos(kaabaLatitude * pi / 180.0) *
              cos(deltaLongitude);

      final bearing = atan2(y, x) * 180 / pi;

      if (mounted) {
        setState(() {
          qiblaDirection = (bearing + 360) % 360;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred: $e';
        });
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied. Cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  String _getCardinalDirection(double angle) {
    if (angle >= 337.5 || angle < 22.5) return 'N';
    if (angle >= 22.5 && angle < 67.5) return 'NE';
    if (angle >= 67.5 && angle < 112.5) return 'E';
    if (angle >= 112.5 && angle < 157.5) return 'SE';
    if (angle >= 157.5 && angle < 202.5) return 'S';
    if (angle >= 202.5 && angle < 247.5) return 'SW';
    if (angle >= 247.5 && angle < 292.5) return 'W';
    if (angle >= 292.5 && angle < 337.5) return 'NW';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Compass'),
        centerTitle: true,
      ),
      body: errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : qiblaDirection == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<CompassEvent>(
                  stream: FlutterCompass.events,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data?.heading == null) {
                      return const Center(
                        child: Text(
                          'Compass not available.',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      );
                    }

                    final heading = snapshot.data!.heading!;
                    final qiblaAngle = qiblaDirection!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Qibla Compass
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Qibla Arrow
                            Transform.rotate(
                              angle: -qiblaAngle * pi / 180,
                              child: Icon(
                                Icons.navigation,
                                size: 150,
                                color: Colors.red,
                              ),
                            ),
                            // Heading Arrow
                            Transform.rotate(
                              angle: -heading * pi / 180,
                              child: Icon(
                                Icons.navigation,
                                size: 150,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Qibla Direction Text
                        Text(
                          '${qiblaAngle.toStringAsFixed(1)}° ${_getCardinalDirection(qiblaAngle)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Qibla Direction from North',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        // Latitude and Longitude
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Latitude : ${currentPosition?.latitude.toStringAsFixed(4) ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Longitude : ${currentPosition?.longitude.toStringAsFixed(4) ?? "N/A"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
