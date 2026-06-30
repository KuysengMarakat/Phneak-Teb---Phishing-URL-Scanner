import '../config/constants.dart';
import '../data/repositories/blocklist_repository.dart';
import '../data/repositories/smart_blocklist_repository.dart';
import '../data/repositories/url_repository.dart';
import '../models/scan_report.dart';
import '../models/scan_result.dart';
import '../models/url_record.dart';
import '../utils/url_validator.dart';

/// Orchestrates the full scan pipeline:
/// 1. Validate the URL.
/// 2. Check local static blocklist (instant).
/// 3. Check smart (learning) blocklist (instant).
/// 4. Fall back to the VirusTotal API.
/// 5. Persist the result and update the learning blocklist.
class ScanService {
  final UrlRepository _urlRepo;
  final BlocklistRepository _blocklist;
  final SmartBlocklistRepository _smartBlocklist;

  ScanService({
    UrlRepository? urlRepo,
    BlocklistRepository? blocklist,
    SmartBlocklistRepository? smartBlocklist,
  })  : _urlRepo = urlRepo ?? UrlRepository(),
        _blocklist = blocklist ?? BlocklistRepository(),
        _smartBlocklist = smartBlocklist ?? SmartBlocklistRepository();

  Future<ScanResult> scan(String rawUrl) async {
    final url = UrlValidator.normalize(rawUrl);

    if (!UrlValidator.isValid(url)) {
      return ScanResult(
        url: rawUrl,
        verdict: Verdict.unknown,
        message: 'Invalid URL format.',
        scannedAt: DateTime.now(),
      );
    }

    // 2 & 3: instant local checks.
    if (await _blocklist.isBlocked(url) ||
        await _smartBlocklist.isKnownBad(url)) {
      final result = ScanResult(
        url: url,
        verdict: Verdict.malicious,
        message: 'Matched a known phishing/malicious domain.',
        scannedAt: DateTime.now(),
      );
      await _persist(result, fromBlocklist: true);
      return result;
    }

    // 4: VirusTotal lookup.
    final ScanReport report = await _urlRepo.fetchReport(url);
    final verdict = ScanResult.verdictFromCounts(
      report.malicious,
      report.suspicious,
    );

    final result = ScanResult(
      url: url,
      verdict: verdict,
      maliciousCount: report.malicious,
      suspiciousCount: report.suspicious,
      harmlessCount: report.harmless,
      totalEngines: report.totalEngines,
      message: _messageFor(verdict, report),
      scannedAt: DateTime.now(),
    );

    await _persist(result, fromBlocklist: false);

    // 5: teach the smart blocklist.
    if (result.isDangerous) {
      final host = Uri.tryParse(url)?.host ?? '';
      if (host.isNotEmpty) await _smartBlocklist.recordHit(host);
    }

    return result;
  }

  Future<void> _persist(ScanResult r, {required bool fromBlocklist}) {
    return _urlRepo.saveRecord(
      UrlRecord(
        url: r.url,
        verdict: r.verdict,
        maliciousCount: r.maliciousCount,
        suspiciousCount: r.suspiciousCount,
        totalEngines: r.totalEngines,
        scannedAt: r.scannedAt,
        fromBlocklist: fromBlocklist,
      ),
    );
  }

  String _messageFor(Verdict v, ScanReport report) {
    switch (v) {
      case Verdict.safe:
        return 'No security vendors flagged this URL as malicious.';
      case Verdict.suspicious:
        return '${report.malicious + report.suspicious} vendor(s) flagged '
            'this URL as suspicious.';
      case Verdict.malicious:
        return '${report.malicious} security vendor(s) flagged this URL as '
            'malicious. Do not proceed.';
      case Verdict.unknown:
        return 'Unable to determine the safety of this URL.';
    }
  }
}
