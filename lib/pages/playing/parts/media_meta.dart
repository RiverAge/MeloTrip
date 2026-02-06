part of '../playing_page.dart';

class _MediaMeta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 使用 M3 语义化颜色，配合透明度
    final contentColor = colorScheme.onSurfaceVariant;

    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        final tracks = player.tracks.audio.where((e) => e.codec != null);
        if (tracks.isEmpty) {
          return SizedBox.shrink();
        }
        final track = tracks.first;

        String samplerate = track.samplerate != null
            ? "${(track.samplerate! / 1000).toStringAsFixed(1)} kHz"
            : '';
        String bitrate = track.bitrate != null
            ? "${(track.bitrate! / 1000).round()} kbps"
            : '';
        String effectiveText =
            "$samplerate${samplerate != '' && bitrate != '' ? ' • ' : ''}$bitrate";

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          // 给整体加一个非常淡的背景，确保在任何颜色封面上都能看清
          decoration: BoxDecoration(
            color: contentColor.withAlpha(10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ALAC 徽章
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: contentColor.withAlpha(30), // 稍微加深一点作为区分
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  track.codec?.toUpperCase() ?? '-',
                  style: TextStyle(
                    height: 1.0,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: contentColor, // 自动跟随系统深浅色
                  ),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                    leadingDistribution: TextLeadingDistribution.even,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 参数文字
              Text(
                effectiveText,
                style: TextStyle(
                  height: 1.0,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: contentColor.withAlpha(180), // 略显低调
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
