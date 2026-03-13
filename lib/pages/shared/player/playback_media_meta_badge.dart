import 'package:flutter/material.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class PlaybackMediaMetaBadge extends StatelessWidget {
  const PlaybackMediaMetaBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = colorScheme.onSurfaceVariant;

    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        final tracks = player.tracks.audio.where((e) => e.codec != null);
        if (tracks.isEmpty) return const SizedBox.shrink();

        final track = tracks.first;
        final channelText = _getChannelLabel(
          context: context,
          channels: track.channels,
          count: track.channelscount,
        );

        final samplerate = track.samplerate != null
            ? AppLocalizations.of(context)!.audioSampleRateKHz(
                (track.samplerate! / 1000).toStringAsFixed(1),
              )
            : '';
        final bitrate = track.bitrate != null
            ? AppLocalizations.of(
                context,
              )!.audioBitrateKbps((track.bitrate! / 1000).round().toString())
            : '';
        final infoText = samplerate.isNotEmpty && bitrate.isNotEmpty
            ? '$samplerate / $bitrate'
            : '$samplerate$bitrate';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: contentColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: .min,
            children: [
              _buildBadge(track.codec?.toUpperCase() ?? '-', contentColor),
              if (channelText.isNotEmpty) ...[
                const SizedBox(width: 4),
                _buildBadge(channelText, contentColor),
              ],
              if (infoText.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  infoText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: .w700,
                    color: contentColor.withValues(alpha: 0.86),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getChannelLabel({
    required BuildContext context,
    required String? channels,
    required int? count,
  }) {
    final l10n = AppLocalizations.of(context)!;
    if (channels == null && count == null) return '';
    final c = channels?.toLowerCase() ?? '';
    if (c.contains('stereo') || count == 2) return l10n.audioChannelStereo;
    if (c.contains('mono') || count == 1) return l10n.audioChannelMono;
    if (count != null && count > 2) return l10n.audioChannelCount(count);
    return channels?.toUpperCase() ?? '';
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: .bold,
          color: color,
        ),
      ),
    );
  }
}
