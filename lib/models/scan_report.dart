/// Wraps the raw VirusTotal JSON analysis response and exposes
/// convenient accessors for the parts the app cares about.
class ScanReport {
  final String url;
  final Map<String, dynamic> raw;

  const ScanReport({required this.url, required this.raw});

  factory ScanReport.fromJson(String url, Map<String, dynamic> json) =>
      ScanReport(url: url, raw: json);

  Map<String, dynamic> get _stats {
    final attributes =
        (raw['data']?['attributes'] as Map<String, dynamic>?) ?? const {};
    return (attributes['last_analysis_stats'] as Map<String, dynamic>?) ??
        const {};
  }

  int get malicious => _asInt(_stats['malicious']);
  int get suspicious => _asInt(_stats['suspicious']);
  int get harmless => _asInt(_stats['harmless']);
  int get undetected => _asInt(_stats['undetected']);
  int get timeout => _asInt(_stats['timeout']);

  int get totalEngines =>
      malicious + suspicious + harmless + undetected + timeout;

  /// Per-engine results, e.g. {"Engine A": "malicious", ...}.
  Map<String, String> get engineResults {
    final attributes =
        (raw['data']?['attributes'] as Map<String, dynamic>?) ?? const {};
    final results =
        (attributes['last_analysis_results'] as Map<String, dynamic>?) ??
            const {};
    return results.map(
      (engine, value) => MapEntry(
        engine,
        (value as Map<String, dynamic>)['category']?.toString() ?? 'unknown',
      ),
    );
  }

  static int _asInt(Object? v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
}
