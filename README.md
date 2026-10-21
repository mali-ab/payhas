# Sözi Tap

Flutter word game built around Turkmen proverbs, with account login and a local API.

## Run the API

The backend stores accounts and profile changes in `backend/payhas.db` (created
automatically). Start it before running the app:

```sh
cd backend
python -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/uvicorn main:app --reload
```

For Android emulators the app defaults to `http://10.0.2.2:8000`. For iOS,
desktop, or web, set the endpoint when launching Flutter, for example:

```sh
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

Open `http://localhost:8000/docs` to test the API endpoints directly.

### Run the API in production with Docker

Build and start the backend from the project root:

```sh
docker compose up -d --build
```

The API is available at `http://localhost:8080`, with interactive docs at
`http://localhost:8080/docs`. SQLite data is stored in the named
`backend_data` volume and survives container recreation.

Check the service or stop it with:

```sh
docker compose ps
docker compose down
```

### Development test data

The app includes 126 proverb questions in `assets/proverbs.json`. To add three
development-only test accounts, run this from `backend/` after installing the
requirements:

```sh
.venv/bin/python seed.py
```

Use `test@example.com` (or `owl@example.com` / `mergen@example.com`) with the
password `testpass123`. New accounts always start with zero score, coins, XP,
streaks, completed questions, and achievements; progress is stored separately
for each signed-in account on the device. The seeded accounts have sample
ranking scores, so they appear in the rating screen.

## Build an Android APK

Install the Flutter SDK and Android Studio/Android SDK first, then run these
commands from the project root:

```sh
flutter pub get
flutter build apk --release
```

The release APK is written to:

```text
build/app/outputs/flutter-apk/app-release.apk
```

### API address for Android

The default API address (`http://10.0.2.2:8000`) works only in the Android
emulator. For a physical phone, start the API on your computer and use its LAN
IP address instead (the phone and computer must be on the same network):

```sh
flutter build apk --release \
  --dart-define=API_BASE_URL=http://192.168.1.10:8000
```

Replace `192.168.1.10` with your computer's local IP. For a production build,
use a publicly reachable HTTPS API URL rather than local HTTP.

## Build an iOS app

Building iOS requires macOS with Xcode and a configured Apple developer signing
team. From the project root, install dependencies and open the iOS workspace:

```sh
flutter pub get
open ios/Runner.xcworkspace
```

In Xcode, select **Runner** → **Signing & Capabilities**, choose your Apple
Development Team, and set a unique Bundle Identifier. You can then run it on a
connected iPhone or simulator with:

```sh
flutter run --dart-define=API_BASE_URL=http://YOUR_COMPUTER_IP:8000
```

Replace `YOUR_COMPUTER_IP` with your Mac's LAN IP. `localhost` does not point
to the Mac when the app is running on a physical iPhone. Keep the phone and Mac
on the same Wi-Fi network while testing.

To create an archive for TestFlight or the App Store:

```sh
flutter build ipa --release \
  --dart-define=API_BASE_URL=https://api.example.com
```

The generated archive and IPA are placed in `build/ios/archive/` and
`build/ios/ipa/`. Upload the archive through Xcode Organizer or Transporter.
Use an HTTPS API endpoint for TestFlight and App Store releases.

## Local-first data

`assets/proverbs.json` ships with 126 questions. Every entry carries an id,
proverb with a blank, answer, four options, category, difficulty and a Turkmen
explanation. The app loads this bundle with no network request.

Gameplay talks only to `ProverbRepository`. A normal local build reads
`assets/proverbs.json`. Supplying `--dart-define=API_BASE_URL=https://...`
automatically switches questions to the database-backed API. For the default
Android-emulator URL, add `--dart-define=USE_REMOTE_API=true` explicitly.
