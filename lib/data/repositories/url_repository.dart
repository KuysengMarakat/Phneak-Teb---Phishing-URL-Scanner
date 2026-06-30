import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/api_keys.dart';
import '../../config/constants.dart';
import '../../models/scan_report.dart';
import '../database/database_helper.dart';
import '../../models/url_record.dart';

/// Talks to the VirusTotal API and persists scan history.
class UrlRepository {
  final http.Client _client;
  UrlRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Submit a URL for analysis and fetch its report.
  ///
  /// VirusTotal uses a URL identifier which is the base64 (url-safe, no
  /// padding) encoding of the URL.
  Future<ScanReport> fetchReport(String url) async {
    if (!ApiKeys.isConfigured) {
      throw StateError(
        'VirusTotal API key is not configured. See lib/config/api_keys.dart.',
      );
    }

    final id = _urlId(url);
    final uri = Uri.parse('${AppConstants.vtBaseUrl}/urls/$id');

    final response = await _client.get(
      uri,
      headers: {'x-apikey': ApiKeys.virusTotalApiKey},
    ).timeout(AppConstants.apiTimeout);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return ScanReport.fromJson(url, json);
    }

    if (response.statusCode == 404) {
      // URL not yet analysed: submit it for scanning.
      await _submitUrl(url);
      throw StateError('URL submitted for analysis. Try again shortly.');
    }

    throw http.ClientException(
      'VirusTotal error ${response.statusCode}: ${response.body}',
    );
  }

  Future<void> _submitUrl(String url) async {
    final uri = Uri.parse('${AppConstants.vtBaseUrl}/urls');
    await _client.post(
      uri,
      headers: {
        'x-apikey': ApiKeys.virusTotalApiKey,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'url': url},
    ).timeout(AppConstants.apiTimeout);
  }

  String _urlId(String url) {
    final bytes = utf8.encode(url);
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  // ---- History persistence ----

  Future<int> saveRecord(UrlRecord record) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('url_history', record.toMap());
  }

  Future<List<UrlRecord>> getHistory() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('url_history', orderBy: 'scanned_at DESC');
    return rows.map(UrlRecord.fromMap).toList();
  }

  Future<void> clearHistory() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('url_history');
  }

  void dispose() => _client.close();
}
