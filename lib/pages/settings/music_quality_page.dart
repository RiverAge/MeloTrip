import 'package:flutter/material.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class MusicQualityPage extends StatelessWidget {
  final _list = ['16', '32', '128', '256', '0'];

  MusicQualityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.musicQuality),
        elevation: 3,
      ),
      body: ListView.separated(
        separatorBuilder: (_, _) => const Divider(),
        itemCount: _list.length,
        itemBuilder: (contex, index) {
          return AsyncValueBuilder(
            provider: userConfigProvider,
            builder: (context, data, ref) {
              return ListTile(
                title: Text(
                  _list[index] == '0'
                      ? AppLocalizations.of(context)!.musicQualityLossless
                      : '${_list[index]}kbps',
                ),
                subtitle: Text(
                  [
                    AppLocalizations.of(context)!.musicQualitySmooth,
                    AppLocalizations.of(context)!.musicQualityMedium,
                    AppLocalizations.of(context)!.musicQualityHigh,
                    AppLocalizations.of(context)!.musicQualityVeryHigh,
                    '',
                  ][index],
                ),
                trailing:
                    data.maxRate == _list[index]
                        ? const Icon(Icons.check)
                        : null,
                onTap: () {
                  ref
                      .read(userConfigProvider.notifier)
                      .setConfiguration(maxRate: ValueUpdater(_list[index]));
                },
              );
            },
          );
        },
      ),
    );
  }
}
