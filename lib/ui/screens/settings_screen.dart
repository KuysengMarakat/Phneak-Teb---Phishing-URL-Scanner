import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/biometric_service.dart';
import '../../utils/translations.dart';
import 'login_screen.dart';

/// User-configurable settings: language, theme, biometrics, logout.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = AuthRepository();
  final _biometric = BiometricService();

  bool _biometricEnabled = false;
  bool _khmer = Translations.language == 'km';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled =
          prefs.getBool(AppConstants.prefBiometricEnabled) ?? false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && !await _biometric.isAvailable()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometrics not available.')),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefBiometricEnabled, value);
    setState(() => _biometricEnabled = value);
  }

  Future<void> _toggleLanguage(bool khmer) async {
    Translations.setLanguage(khmer ? 'km' : 'en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguage, khmer ? 'km' : 'en');
    setState(() => _khmer = khmer);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Khmer language (ភាសាខ្មែរ)'),
          secondary: const Icon(Icons.translate),
          value: _khmer,
          onChanged: _toggleLanguage,
        ),
        SwitchListTile(
          title: const Text('Biometric login'),
          secondary: const Icon(Icons.fingerprint),
          value: _biometricEnabled,
          onChanged: _toggleBiometric,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Logout'),
          onTap: _logout,
        ),
      ],
    );
  }
}
