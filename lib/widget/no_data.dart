import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(
      context,
    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 0.5,
            color: color,
            margin: const EdgeInsets.only(right: 5),
          ),
          Text(
            AppLocalizations.of(context)!.noDataFound,
            style: TextStyle(color: color),
          ),
          Container(
            width: 50,
            height: 0.5,
            color: color,
            margin: const EdgeInsets.only(left: 5),
          ),
        ],
      ),
    );
  }
}
