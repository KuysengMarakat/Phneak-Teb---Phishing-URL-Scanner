import 'package:flutter/material.dart';

import '../../config/theme.dart';

/// The Phneak Teb "divine eye" logo. Falls back to an icon if the asset
/// is missing so the scaffold runs without bundled images.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showLabel;

  const AppLogo({super.key, this.size = 96, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/eye_logo.png',
          width: size,
          height: size,
          errorBuilder: (_, __, ___) => Icon(
            Icons.remove_red_eye,
            size: size,
            color: AppTheme.accent,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 12),
          Text(
            'Phneak Teb',
            style: TextStyle(
              fontSize: size * 0.25,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
            ),
          ),
        ],
      ],
    );
  }
}
