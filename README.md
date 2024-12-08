
# Prayer App

A simple, ad-free Flutter application designed to provide accurate daily prayer times and a Qibla compass for Muslims worldwide.

## Features

- **Ad-Free Experience**: Check prayer times and use the Qibla compass without interruptions.
- **Accurate Prayer Times**: Automatically fetches daily prayer times based on your location.
- **Qibla Compass**: Helps you find the correct direction to face for prayer.
- **City and State Detection**: Displays your current location (city and state) to ensure accurate results.
- **User-Friendly Design**: Clean and intuitive interface with a minimalistic black-and-white theme.

## Why Choose Prayer App?

This application is ideal for anyone looking to avoid advertisements while staying on top of their daily prayers. It combines simplicity and utility, ensuring a distraction-free experience for Muslims who rely on accurate prayer times and Qibla direction.

## How to Install and Run

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/tareqmus/prayer_app.git
   cd prayer_app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   ```bash
   flutter run
   ```

> **Note**: Ensure Flutter is installed on your system. Refer to the [Flutter installation guide](https://docs.flutter.dev/get-started/install) for setup instructions.

## Screenshots
_Add screenshots of your app here to showcase the design and functionality._

## Tech Stack

- **Flutter**: Cross-platform UI toolkit for building iOS and Android apps.
- **Geolocator**: Detects your location for accurate prayer times and Qibla direction.
- **Geocoding**: Converts latitude and longitude into human-readable addresses (city and state).
- **Flutter Compass**: Provides Qibla compass functionality using device sensors.
- **HTTP**: Fetches prayer times from the [Aladhan API](https://aladhan.com/).
- **Intl**: Formats times into a user-friendly 12-hour format with AM/PM.

## How it Works

1. **Prayer Times**:
   - Automatically detects your location and fetches prayer times using the [Aladhan API](https://aladhan.com/).
   - Displays prayer times in a clean and simple format.

2. **Qibla Compass**:
   - Uses your device's sensors to determine the Qibla direction based on your location.

3. **Location Display**:
   - Displays your current city and state, ensuring users have confidence in the app's accuracy.

## Privacy Policy

Your location is used solely to fetch prayer times and determine the Qibla direction. The app does not collect, store, or share your data.

## Contributing

Contributions are welcome! Here's how you can help:

1. Fork this repository.
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request on GitHub.

## License

This project is licensed under the Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

