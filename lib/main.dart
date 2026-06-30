import 'package:flutter/material.dart';

import 'config/constants.dart';
import 'config/theme.dart';
import 'services/notification_service.dart';
import 'ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services before the app starts.
  await NotificationService.instance.init();

  runApp(const PhneakTebApp());
}

/// Root widget for the Phneak Teb application.
class PhneakTebApp extends StatelessWidget {
  const PhneakTebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
