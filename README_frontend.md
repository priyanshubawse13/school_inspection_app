
# 📱 School Inspection Frontend (Flutter)

## 📌 Overview
Flutter app for conducting real-time inspections of schools. Users can log in, rate schools, take photos, and upload inspection data with location support.

## 📱 Features
- User Login with JWT token
- Dashboard with role-based navigation
- Inspection form with:
  - Dropdown ratings
  - Camera integration
  - Live location
  - Submission to backend API

## 🔧 Tech Stack
- Flutter (Dart)
- HTTP package
- Image Picker
- Geolocator
- Path + Multipart requests

## 🗂️ Folder Structure
```
school_inspection_app/
├── lib/
│   ├── Screens/
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── inspection_form_screen.dart
│   └── main.dart
└── pubspec.yaml
```

## 📦 Setup
```bash
flutter pub get
flutter run
```

## 🔐 Login Credentials (for testing)
Make sure your MongoDB has users like:
```json
{
  "name": "Inspector Raj",
  "email": "raj@example.com",
  "password": "<hashed_password>",
  "role": "inspector"
}
```
