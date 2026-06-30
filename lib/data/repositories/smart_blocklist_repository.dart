import '../database/database_helper.dart';

/// A "learning" blocklist stored in SQLite. Each time a domain is flagged
/// as malicious/suspicious, its hit count increases. Frequently seen
/// domains can be blocked instantly without an API round-trip.
class SmartBlocklistRepository {
  /// Record that [domain] was flagged, incrementing its hit count.
  Future<void> recordHit(String domain) async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now().toIso8601String();
    final normalized = domain.toLowerCase();

    final existing = await db.query(
      'smart_blocklist',
      where: 'domain = ?',
      whereArgs: [normalized],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert('smart_blocklist', {
        'domain': normalized,
        'hit_count': 1,
        'last_seen': now,
      });
    } else {
      final count = (existing.first['hit_count'] as int? ?? 0) + 1;
      await db.update(
        'smart_blocklist',
        {'hit_count': count, 'last_seen': now},
        where: 'domain = ?',
        whereArgs: [normalized],
      );
    }
  }

  /// Returns true if [url]'s host has been flagged before.
  Future<bool> isKnownBad(String url) async {
    final host = Uri.tryParse(url)?.host.toLowerCase() ?? '';
    if (host.isEmpty) return false;
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'smart_blocklist',
      where: 'domain = ?',
      whereArgs: [host],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<Map<String, Object?>>> all() async {
    final db = await DatabaseHelper.instance.database;
    return db.query('smart_blocklist', orderBy: 'hit_count DESC');
  }
}
