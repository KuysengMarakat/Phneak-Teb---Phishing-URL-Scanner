import 'package:flutter_test/flutter_test.dart';
import 'package:phneak_teb/utils/url_validator.dart';

void main() {
  group('UrlValidator.normalize', () {
    test('adds https:// when scheme is missing', () {
      expect(UrlValidator.normalize('example.com'), 'https://example.com');
    });

    test('keeps existing scheme', () {
      expect(UrlValidator.normalize('http://example.com'),
          'http://example.com');
    });
  });

  group('UrlValidator.isValid', () {
    test('accepts valid hostnames', () {
      expect(UrlValidator.isValid('https://example.com'), isTrue);
      expect(UrlValidator.isValid('https://sub.example.co.uk'), isTrue);
    });

    test('accepts IPv4 addresses', () {
      expect(UrlValidator.isValid('http://192.168.1.1'), isTrue);
    });

    test('rejects malformed input', () {
      expect(UrlValidator.isValid('not a url'), isFalse);
      expect(UrlValidator.isValid('https://'), isFalse);
    });
  });
}
