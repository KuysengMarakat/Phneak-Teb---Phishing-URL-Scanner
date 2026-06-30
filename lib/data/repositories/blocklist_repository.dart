import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../config/constants.dart';

/// Loads and queries the bundled static blocklist (assets/local_blocklist.json).
class BlocklistRepository {
  Set<String>? _domains;

  /// Lazily load the blocklist from the asset bundle.
  Future<Set<String>> _load() async {
    if (_domains != null) return _domains!;
    final raw = await rootBundle.loadString(AppConstants.localBlocklistPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final list = (json['domains'] as List<dynamic>? ?? [])
        .map((e) => e.toString().toLowerCase())
        .toSet();
    _domains = list;
    return list;
  }

  /// Returns true if the host of [url] is on the static blocklist.
  Future<bool> isBlocked(String url) async {
    final domains = await _load();
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    if (host.isEmpty) return false;
    return domains.any((d) => host == d || host.endsWith('.$d'));
  }
}
