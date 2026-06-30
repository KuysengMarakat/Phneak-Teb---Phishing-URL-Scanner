import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../config/constants.dart';
import '../models/scan_result.dart';

/// Handles local notifications (e.g. alerting the user about a dangerous URL).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> showScanResult(ScanResult result) async {
    if (!_initialized) await init();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'scan_results',
        'Scan Results',
        channelDescription: 'Notifications about URL scan verdicts',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final title = result.verdict == Verdict.malicious
        ? '⚠️ Dangerous URL detected'
        : result.verdict == Verdict.suspicious
            ? '⚠️ Suspicious URL'
            : '✅ URL is safe';

    await _plugin.show(
      result.url.hashCode,
      title,
      result.message,
      details,
    );
  }
}
