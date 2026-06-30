import 'package:flutter/material.dart';

import '../../models/url_record.dart';
import '../../utils/color_helper.dart';
import '../../utils/date_formatter.dart';

/// A single row in the scan history list.
class ScanListItem extends StatelessWidget {
  final UrlRecord record;
  final VoidCallback? onTap;

  const ScanListItem({super.key, required this.record, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = ColorHelper.colorFor(record.verdict);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(ColorHelper.iconFor(record.verdict), color: color),
      ),
      title: Text(
        record.url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${ColorHelper.labelFor(record.verdict)} • '
        '${DateFormatter.relative(record.scannedAt)}',
        style: TextStyle(color: color),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
