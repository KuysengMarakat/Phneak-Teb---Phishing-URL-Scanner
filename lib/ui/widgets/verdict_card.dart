import 'package:flutter/material.dart';

import '../../models/scan_result.dart';
import '../../utils/color_helper.dart';

/// A prominent card summarizing a scan verdict.
class VerdictCard extends StatelessWidget {
  final ScanResult result;

  const VerdictCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = ColorHelper.colorFor(result.verdict);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(ColorHelper.iconFor(result.verdict), size: 64, color: color),
            const SizedBox(height: 12),
            Text(
              ColorHelper.labelFor(result.verdict),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            SelectableText(
              result.url,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Text(result.message, textAlign: TextAlign.center),
            if (result.totalEngines > 0) ...[
              const Divider(height: 24),
              _StatsRow(result: result),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ScanResult result;
  const _StatsRow({required this.result});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stat('Malicious', result.maliciousCount, Colors.red),
        _stat('Suspicious', result.suspiciousCount, Colors.orange),
        _stat('Harmless', result.harmlessCount, Colors.green),
        _stat('Total', result.totalEngines, Colors.blueGrey),
      ],
    );
  }

  Widget _stat(String label, int value, Color color) => Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      );
}
