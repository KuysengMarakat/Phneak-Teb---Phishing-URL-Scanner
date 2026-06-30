# Setup Guide

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.0 or newer
- A device or emulator (Android/iOS)
- A free [VirusTotal API key](https://www.virustotal.com/gui/my-apikey)

## 1. Install dependencies

```bash
flutter pub get
```

## 2. Add the Khmer fonts (optional but recommended)

Download **Battambang** from Google Fonts and place the files in
`assets/fonts/`:

- `Battambang-Regular.ttf`
- `Battambang-Bold.ttf`

## 3. Add image assets (optional)

Place the following in `assets/images/`: `logo.png`, `splash.png`,
`eye_logo.png`, `safe_icon.png`, `suspicious_icon.png`, `malicious_icon.png`.
The app falls back to Material icons if these are missing.

## 4. Configure the VirusTotal API key

Either edit `lib/config/api_keys.dart` directly, or pass it at runtime:

```bash
flutter run --dart-define=VT_API_KEY=your_real_key
```

## 5. Platform permissions

The QR scanner and biometrics require permissions:

- **Android** (`android/app/src/main/AndroidManifest.xml`):
  - `<uses-permission android:name="android.permission.CAMERA"/>`
  - `<uses-permission android:name="android.permission.USE_BIOMETRIC"/>`
- **iOS** (`ios/Runner/Info.plist`):
  - `NSCameraUsageDescription`
  - `NSFaceIDUsageDescription`

## 6. Run

```bash
flutter run
```

## 7. Build a release

```bash
flutter build apk --release --dart-define=VT_API_KEY=your_real_key   # Android
flutter build ios --release --dart-define=VT_API_KEY=your_real_key   # iOS
```

## Troubleshooting

| Problem                          | Fix                                            |
|----------------------------------|------------------------------------------------|
| "API key not configured"         | Set `VT_API_KEY` or edit `api_keys.dart`        |
| "URL submitted for analysis"     | Wait a few seconds and scan again              |
| Camera not opening               | Confirm camera permission is granted           |
| Khmer text shows boxes           | Ensure Battambang fonts are in `assets/fonts/` |
