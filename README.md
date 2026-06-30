# 👁️ Phneak Teb — Phishing URL Scanner

> **Phneak Teb** (ភ្នែកទេព — "Divine Eye") is a Flutter mobile app that scans URLs and QR codes
> to detect phishing and malicious links, powered by the VirusTotal API and a learning blocklist.

---

## ✨ Features

- 🔍 **URL scanning** via the VirusTotal API
- 📷 **QR code scanning** with the device camera
- 🧠 **Smart blocklist** that learns from past scans (local SQLite DB)
- 🗂️ **Scan history** with detailed verdict reports
- 📊 **Statistics** dashboard
- 🔐 **Biometric login** (fingerprint / face)
- 🔔 **Local notifications** for scan results
- 🇰🇭 **Khmer language support** (Battambang font)

---

## 🏗️ Architecture

The app follows a layered architecture:

```
UI (screens / widgets)
        ↓
Services (scan, biometric, notification)
        ↓
Data (repositories + SQLite database)
        ↓
Models (user, url_record, scan_result, scan_report)
```

See [`docs/architecture.md`](docs/architecture.md) for details.

---

## 📁 Project Structure

```
lib/
├── main.dart              # App entry point
├── config/                # api_keys, constants, theme
├── models/                # Data models
├── data/                  # Repositories + database
├── services/              # Business logic
├── ui/                    # Screens + widgets
└── utils/                 # Helpers + translations
```

---

## 🚀 Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Add your VirusTotal API key
#    Edit lib/config/api_keys.dart and set virusTotalApiKey

# 3. Run the app
flutter run
```

See [`docs/setup_guide.md`](docs/setup_guide.md) for the full setup walkthrough.

---

## 👥 Team

| Area | Owner |
|------|-------|
| 🎨 UI / Assets / Khmer | **Marakat** |
| 🧠 Logic / Data / Services | **Vathanak** |
| 🤝 Shared (main, utils, docs) | **Both** |

---

## 📄 License

See [LICENSE](LICENSE).
