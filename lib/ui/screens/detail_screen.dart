import 'package:flutter/material.dart';

import '../../models/scan_result.dart';
import '../../models/url_record.dart';
import '../../utils/date_formatter.dart';
import '../widgets/verdict_card.dart';

/// Shows the full details of a single past scan.
class DetailScreen extends StatelessWidget {
  final UrlRecord record;

  const DetailScreen({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final result = ScanResult(
      url: record.url,
      verdict: record.verdict,
      maliciousCount: record.maliciousCount,
      suspiciousCount: record.suspiciousCount,
      totalEngines: record.totalEngines,
      message: record.fromBlocklist
          ? 'Matched a known blocklisted domain.'
          : 'Result from VirusTotal analysis.',
      scannedAt: record.scannedAt,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Details')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          VerdictCard(result: result),
          const SizedBox(height: 20),
          _InfoRow(label: 'URL', value: record.url),
          _InfoRow(
            label: 'Scanned at',
            value: DateFormatter.full(record.scannedAt),
          ),
          _InfoRow(
            label: 'Source',
            value: record.fromBlocklist ? 'Local blocklist' : 'VirusTotal API',
          ),
          _InfoRow(
            label: 'Engines flagged',
            value: '${record.maliciousCount + record.suspiciousCount} '
                'of ${record.totalEngines}',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: SelectableText(value)),
        ],
      ),
    );
  }
}
