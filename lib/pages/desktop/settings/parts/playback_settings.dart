import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

class PlaybackSettings extends ConsumerWidget {
  const PlaybackSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final userConfig = ref.watch(sessionConfigProvider).value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: <Widget>[
        Align(
          alignment: .topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SettingSectionHeader(
                  title: l10n.settingsTabPlayback,
                  icon: Icons.play_circle_outline_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingSingleChoiceRow<String>(
                        label: l10n.musicQuality,
                        value: userConfig?.maxRate ?? '32',
                        options: <SettingSingleChoiceOption<String>>[
                          SettingSingleChoiceOption<String>(
                            value: '16',
                            label: '${l10n.musicQualitySmooth} (16kbps)',
                          ),
                          SettingSingleChoiceOption<String>(
                            value: '32',
                            label: '${l10n.musicQualityMedium} (32kbps)',
                          ),
                          SettingSingleChoiceOption<String>(
                            value: '128',
                            label: '${l10n.musicQualityHigh} (128kbps)',
                          ),
                          SettingSingleChoiceOption<String>(
                            value: '256',
                            label: '${l10n.musicQualityVeryHigh} (256kbps)',
                          ),
                          SettingSingleChoiceOption<String>(
                            value: '0',
                            label: l10n.musicQualityLossless,
                          ),
                        ],
                        onChanged: (String value) {
                          ref.read(userSessionProvider.notifier).setConfiguration(
                                maxRate: ValueUpdater<String?>(value),
                              );
                        },
                      ),
                      SettingSingleChoiceRow<PlaylistMode>(
                        label: l10n.playback,
                        value: userConfig?.playlistMode ?? .none,
                        options: <SettingSingleChoiceOption<PlaylistMode>>[
                          SettingSingleChoiceOption<PlaylistMode>(
                            value: .none,
                            label: l10n.playModeNone,
                            icon: Icons.queue_music_rounded,
                          ),
                          SettingSingleChoiceOption<PlaylistMode>(
                            value: .loop,
                            label: l10n.playModeLoop,
                            icon: Icons.repeat_rounded,
                          ),
                          SettingSingleChoiceOption<PlaylistMode>(
                            value: .single,
                            label: l10n.playModeSingle,
                            icon: Icons.repeat_one_rounded,
                          ),
                        ],
                        onChanged: (PlaylistMode value) {
                          ref.read(userSessionProvider.notifier).setConfiguration(
                                playlistMode: ValueUpdater<PlaylistMode?>(value),
                              );
                        },
                      ),
                      SettingRow(
                        label: l10n.shuffle,
                        trailing: Switch(
                          value: userConfig?.shuffle ?? false,
                          onChanged: (bool value) {
                            ref.read(userSessionProvider.notifier).setConfiguration(
                                  shuffle: ValueUpdater<bool?>(value),
                                );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
