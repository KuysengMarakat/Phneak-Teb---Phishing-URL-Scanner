/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // App identity
  static const String appName = 'Phneak Teb';
  static const String appTagline = 'Divine Eye — Phishing URL Scanner';
  static const String appVersion = '1.0.0';

  // VirusTotal API
  static const String vtBaseUrl = 'https://www.virustotal.com/api/v3';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Local assets
  static const String localBlocklistPath = 'assets/local_blocklist.json';

  // Database
  static const String dbName = 'phneak_teb.db';
  static const int dbVersion = 1;

  // SharedPreferences keys
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefBiometricEnabled = 'biometric_enabled';
  static const String prefLanguage = 'language';
  static const String prefDarkMode = 'dark_mode';

  // Scan thresholds: number of engines flagging a URL
  static const int suspiciousThreshold = 1;
  static const int maliciousThreshold = 3;
}

/// Verdict categories returned by a scan.
enum Verdict { safe, suspicious, malicious, unknown }
