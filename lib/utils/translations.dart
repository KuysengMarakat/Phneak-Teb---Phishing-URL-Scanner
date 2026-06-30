/// Lightweight Khmer/English string lookup.
///
/// For a production app consider `flutter_localizations` + ARB files;
/// this map keeps the scaffold dependency-free.
class Translations {
  Translations._();

  static String _lang = 'en';

  static void setLanguage(String code) => _lang = code;
  static String get language => _lang;

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_name': 'Phneak Teb',
      'scan': 'Scan',
      'history': 'History',
      'statistics': 'Statistics',
      'settings': 'Settings',
      'about': 'About',
      'login': 'Login',
      'logout': 'Logout',
      'scan_url_hint': 'Enter a URL to scan',
      'scan_button': 'Scan URL',
      'qr_scan': 'Scan QR Code',
      'safe': 'Safe',
      'suspicious': 'Suspicious',
      'malicious': 'Malicious',
      'no_history': 'No scans yet',
    },
    'km': {
      'app_name': 'ភ្នែកទេព',
      'scan': 'ស្កេន',
      'history': 'ប្រវត្តិ',
      'statistics': 'ស្ថិតិ',
      'settings': 'ការកំណត់',
      'about': 'អំពី',
      'login': 'ចូល',
      'logout': 'ចេញ',
      'scan_url_hint': 'បញ្ចូល URL ដើម្បីស្កេន',
      'scan_button': 'ស្កេន URL',
      'qr_scan': 'ស្កេន QR',
      'safe': 'សុវត្ថិភាព',
      'suspicious': 'គួរឱ្យសង្ស័យ',
      'malicious': 'គ្រោះថ្នាក់',
      'no_history': 'មិនទាន់មានការស្កេន',
    },
  };

  /// Look up [key] in the current language, falling back to English then key.
  static String t(String key) {
    return _strings[_lang]?[key] ?? _strings['en']?[key] ?? key;
  }
}
