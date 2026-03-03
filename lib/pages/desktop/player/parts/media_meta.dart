part of '../full_player_page.dart';

class _DesktopMediaMeta extends StatelessWidget {
  const _DesktopMediaMeta();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = colorScheme.onSurface;

    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        final tracks = player.tracks.audio.where((e) => e.codec != null);
        if (tracks.isEmpty) return const SizedBox.shrink();

        final track = tracks.first;

        final channelText = _getChannelLabel(
          l10n,
          track.channels,
          track.channelscount,
        );
        final samplerate = track.samplerate != null
            ? l10n.audioSampleRateKHz(
                (track.samplerate! / 1000).toStringAsFixed(1),
              )
            : '';
        final bitrate = track.bitrate != null
            ? l10n.audioBitrateKbps((track.bitrate! / 1000).round().toString())
            : '';

        String infoText = '';
        if (samplerate.isNotEmpty && bitrate.isNotEmpty) {
          infoText = '$samplerate / $bitrate';
        } else {
          infoText = '$samplerate$bitrate';
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (track.codec != null)
              _buildBadge(track.codec!.toUpperCase(), contentColor),
            if (channelText.isNotEmpty) _buildBadge(channelText, contentColor),
            if (infoText.isNotEmpty)
              Text(
                infoText,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        );
      },
    );
  }

  String _getChannelLabel(
    AppLocalizations l10n,
    String? channels,
    int? count,
  ) {
    if (channels == null && count == null) return '';
    final c = channels?.toLowerCase() ?? '';
    if (c.contains('stereo') || count == 2) return l10n.audioChannelStereo;
    if (c.contains('mono') || count == 1) return l10n.audioChannelMono;
    if (count != null && count > 2) return l10n.audioChannelCount(count);
    return channels?.toUpperCase() ?? '';
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: .3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
