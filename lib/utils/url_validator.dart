/// URL validation and normalization helpers.
class UrlValidator {
  UrlValidator._();

  static final RegExp _hostPattern = RegExp(
    r'^(([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,})$',
  );

  /// Ensure the URL has a scheme. Defaults to https:// if missing.
  static String normalize(String input) {
    var url = input.trim();
    if (url.isEmpty) return url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    return url;
  }

  /// Returns true if [url] parses to an absolute URL with a valid host.
  static bool isValid(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.isAbsolute) return false;
    if (uri.host.isEmpty) return false;
    // Allow IP addresses or dotted hostnames.
    return _hostPattern.hasMatch(uri.host) || _isIpAddress(uri.host);
  }

  static bool _isIpAddress(String host) {
    final parts = host.split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  static String? hostOf(String url) => Uri.tryParse(normalize(url))?.host;
}
