# FitMate – Flutter + Firebase + Riverpod

A cross-platform health & fitness app for workouts, meals, mood tracking, and reminders.

## Features
- Firebase Email/Password Authentication
- CRUD for Workouts, Meals, and Moods (Cloud Firestore)
- Riverpod for scalable state management
- FCM + Local Notifications for reminders
- Material 3 UI with bottom navigation

## Quickstart

1. **Create Flutter project**
```bash
flutter create fitmate && cd fitmate
```

2. **Replace files**
Copy `lib/` and `pubspec.yaml` from this package's `code/` into your project (overwrite existing). Also copy `assets/`.

3. **Install dependencies**
```bash
flutter pub get
```

4. **Configure Firebase**
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
Enable **Authentication**, **Cloud Firestore**, and **Cloud Messaging** in Firebase Console.

5. **Apply Security Rules**
Use files in `rules/` within Firebase Console.

6. **Run**
```bash
flutter run
```

## Firestore Collections

- `workouts` { uid, date (ISO), type, durationMin, calories, notes? }
- `meals` { uid, date (ISO), items [string], calories, protein?, carbs?, fat?, waterMl?, notes? }
- `moods` { uid, date (ISO), mood, note? }

## License
MIT (student project)
