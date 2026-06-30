import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../../data/repositories/url_repository.dart';
import '../../models/url_record.dart';
import '../../utils/color_helper.dart';
import '../widgets/loading_spinner.dart';

/// Aggregated statistics about all scans performed.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _repo = UrlRepository();
  late Future<List<UrlRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UrlRecord>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingSpinner();
        }
        final records = snapshot.data ?? [];
        final counts = <Verdict, int>{
          for (final v in Verdict.values) v: 0,
        };
        for (final r in records) {
          counts[r.verdict] = (counts[r.verdict] ?? 0) + 1;
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _TotalCard(total: records.length),
            const SizedBox(height: 16),
            for (final entry in counts.entries)
              _VerdictTile(verdict: entry.key, count: entry.value),
          ],
        );
      },
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int total;
  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              '$total',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text('Total URLs scanned'),
          ],
        ),
      ),
    );
  }
}

class _VerdictTile extends StatelessWidget {
  final Verdict verdict;
  final int count;
  const _VerdictTile({required this.verdict, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = ColorHelper.colorFor(verdict);
    return Card(
      child: ListTile(
        leading: Icon(ColorHelper.iconFor(verdict), color: color),
        title: Text(ColorHelper.labelFor(verdict)),
        trailing: Text(
          '$count',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
