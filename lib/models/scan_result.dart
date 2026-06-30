import '../config/constants.dart';

/// The verdict produced after analysing a URL.
class ScanResult {
  final String url;
  final Verdict verdict;
  final int maliciousCount;
  final int suspiciousCount;
  final int harmlessCount;
  final int totalEngines;
  final String message;
  final DateTime scannedAt;

  const ScanResult({
    required this.url,
    required this.verdict,
    this.maliciousCount = 0,
    this.suspiciousCount = 0,
    this.harmlessCount = 0,
    this.totalEngines = 0,
    this.message = '',
    required this.scannedAt,
  });

  factory ScanResult.unknown(String url) => ScanResult(
        url: url,
        verdict: Verdict.unknown,
        message: 'No data available for this URL.',
        scannedAt: DateTime.now(),
      );

  /// Derive a [Verdict] from engine detection counts.
  static Verdict verdictFromCounts(int malicious, int suspicious) {
    if (malicious >= AppConstants.maliciousThreshold) return Verdict.malicious;
    if (malicious >= AppConstants.suspiciousThreshold ||
        suspicious >= AppConstants.suspiciousThreshold) {
      return Verdict.suspicious;
    }
    return Verdict.safe;
  }

  bool get isDangerous =>
      verdict == Verdict.malicious || verdict == Verdict.suspicious;
}
