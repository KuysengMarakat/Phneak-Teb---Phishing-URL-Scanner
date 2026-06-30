import 'package:flutter/material.dart';

import '../../data/repositories/url_repository.dart';
import '../../models/url_record.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/scan_list_item.dart';
import 'detail_screen.dart';

/// Displays a list of past scans loaded from the local database.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _repo = UrlRepository();
  late Future<List<UrlRecord>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.getHistory();
  }

  Future<void> _refresh() async {
    setState(() => _future = _repo.getHistory());
    await _future;
  }

  Future<void> _clear() async {
    await _repo.clearHistory();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<List<UrlRecord>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner(message: 'Loading history...');
          }
          final records = snapshot.data ?? [];
          if (records.isEmpty) {
            return const Center(child: Text('No scans yet'));
          }
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clear,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear'),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) => ScanListItem(
                    record: records[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(record: records[i]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
