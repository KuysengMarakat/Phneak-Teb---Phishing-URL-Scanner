import 'package:flutter/material.dart';

import '../config/constants.dart';
import '../config/theme.dart';

/// Maps verdicts to colors, icons and labels used across the UI.
class ColorHelper {
  ColorHelper._();

  static Color colorFor(Verdict verdict) {
    switch (verdict) {
      case Verdict.safe:
        return AppTheme.safe;
      case Verdict.suspicious:
        return AppTheme.suspicious;
      case Verdict.malicious:
        return AppTheme.malicious;
      case Verdict.unknown:
        return Colors.grey;
    }
  }

  static IconData iconFor(Verdict verdict) {
    switch (verdict) {
      case Verdict.safe:
        return Icons.verified_user;
      case Verdict.suspicious:
        return Icons.warning_amber_rounded;
      case Verdict.malicious:
        return Icons.dangerous;
      case Verdict.unknown:
        return Icons.help_outline;
    }
  }

  static String labelFor(Verdict verdict) {
    switch (verdict) {
      case Verdict.safe:
        return 'Safe';
      case Verdict.suspicious:
        return 'Suspicious';
      case Verdict.malicious:
        return 'Malicious';
      case Verdict.unknown:
        return 'Unknown';
    }
  }
}
