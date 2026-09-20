# Sözi Tap

Offline-first Flutter word game built around Turkmen proverbs.

## Local-first data

`assets/proverbs.json` ships with 100 questions. Every entry carries an id,
proverb with a blank, answer, four options, category, difficulty and a Turkmen
explanation. The app loads this bundle with no network request.

Gameplay talks only to `ProverbRepository`. The current composition root uses
`LocalProverbRepository`; a `RemoteProverbRepository` and API endpoint contract
are included as an inactive seam for a future FastAPI/PostgreSQL backend.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
