import 'package:intl/intl.dart';

/// Centralized date/time formatting helpers.
class DateFormatter {
  DateFormatter._();

  static final DateFormat _full = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _dateOnly = DateFormat('dd MMM yyyy');

  static String full(DateTime dt) => _full.format(dt);

  static String dateOnly(DateTime dt) => _dateOnly.format(dt);

  /// Human-friendly relative time, e.g. "3m ago", "2h ago", "5d ago".
  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return _dateOnly.format(dt);
  }
}
