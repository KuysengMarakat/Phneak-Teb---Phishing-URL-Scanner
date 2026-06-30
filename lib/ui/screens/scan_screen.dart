import 'package:flutter/material.dart';

import '../../models/scan_result.dart';
import '../../services/notification_service.dart';
import '../../services/scan_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/verdict_card.dart';
import 'qr_scanner_screen.dart';

/// The main screen where users enter or scan a URL.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _controller = TextEditingController();
  final _scanService = ScanService();

  bool _loading = false;
  String? _error;
  ScanResult? _result;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _scan([String? value]) async {
    final url = (value ?? _controller.text).trim();
    if (url.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _scanService.scan(url);
      await NotificationService.instance.showScanResult(result);
      if (!mounted) return;
      setState(() => _result = result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openQrScanner() async {
    final scanned = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
    if (scanned != null && scanned.isNotEmpty) {
      _controller.text = scanned;
      await _scan(scanned);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _controller,
            label: 'URL',
            hint: 'https://example.com',
            prefixIcon: Icons.link,
            keyboardType: TextInputType.url,
            onSubmitted: _scan,
          ),
          const SizedBox(height: 16),
          CustomButton(
            label: 'Scan URL',
            icon: Icons.shield_outlined,
            isLoading: _loading,
            onPressed: _scan,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _openQrScanner,
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('Scan QR Code'),
          ),
          const SizedBox(height: 24),
          if (_loading) const LoadingSpinner(message: 'Analysing URL...'),
          if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red)),
          if (_result != null) VerdictCard(result: _result!),
        ],
      ),
    );
  }
}
