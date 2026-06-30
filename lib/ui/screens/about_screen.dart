import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../widgets/app_logo.dart';

/// About page describing the app, version, and team.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 12),
          const Center(child: AppLogo(size: 96)),
          const SizedBox(height: 24),
          const Text(
            AppConstants.appTagline,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          const Text(
            'Phneak Teb ("Divine Eye") helps protect you from phishing by '
            'scanning URLs and QR codes against the VirusTotal database and a '
            'learning blocklist. Stay safe online.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.tag),
            title: Text('Version'),
            trailing: Text(AppConstants.appVersion),
          ),
          const ListTile(
            leading: Icon(Icons.group),
            title: Text('Team'),
            subtitle: Text('Marakat (UI) • Vathanak (Logic)'),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Powered by'),
            subtitle: Text('VirusTotal API'),
          ),
        ],
      ),
    );
  }
}
