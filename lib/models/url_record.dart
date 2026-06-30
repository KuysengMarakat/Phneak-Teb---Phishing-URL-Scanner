import '../config/constants.dart';

/// A persisted record of a scanned URL (stored in SQLite history).
class UrlRecord {
  final int? id;
  final String url;
  final Verdict verdict;
  final int maliciousCount;
  final int suspiciousCount;
  final int totalEngines;
  final DateTime scannedAt;
  final bool fromBlocklist;

  const UrlRecord({
    this.id,
    required this.url,
    required this.verdict,
    this.maliciousCount = 0,
    this.suspiciousCount = 0,
    this.totalEngines = 0,
    required this.scannedAt,
    this.fromBlocklist = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'url': url,
        'verdict': verdict.name,
        'malicious_count': maliciousCount,
        'suspicious_count': suspiciousCount,
        'total_engines': totalEngines,
        'scanned_at': scannedAt.toIso8601String(),
        'from_blocklist': fromBlocklist ? 1 : 0,
      };

  factory UrlRecord.fromMap(Map<String, dynamic> map) => UrlRecord(
        id: map['id'] as int?,
        url: map['url'] as String,
        verdict: Verdict.values.firstWhere(
          (v) => v.name == map['verdict'],
          orElse: () => Verdict.unknown,
        ),
        maliciousCount: map['malicious_count'] as int? ?? 0,
        suspiciousCount: map['suspicious_count'] as int? ?? 0,
        totalEngines: map['total_engines'] as int? ?? 0,
        scannedAt: DateTime.parse(map['scanned_at'] as String),
        fromBlocklist: (map['from_blocklist'] as int? ?? 0) == 1,
      );
}
