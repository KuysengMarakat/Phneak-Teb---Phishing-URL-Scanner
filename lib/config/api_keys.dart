/// API keys and secrets.
///
/// ⚠️ Do NOT commit real API keys to version control.
/// Replace the placeholder below with your VirusTotal API key locally,
/// or inject it at build time using `--dart-define`.
///
/// Example:
///   flutter run --dart-define=VT_API_KEY=your_real_key
class ApiKeys {
  ApiKeys._();

  /// VirusTotal API key.
  /// Falls back to the compile-time environment variable `VT_API_KEY`.
  static const String virusTotalApiKey = String.fromEnvironment(
    'VT_API_KEY',
    defaultValue: 'YOUR_VIRUSTOTAL_API_KEY_HERE',
  );

  static bool get isConfigured =>
      virusTotalApiKey.isNotEmpty &&
      virusTotalApiKey != 'YOUR_VIRUSTOTAL_API_KEY_HERE';
}
