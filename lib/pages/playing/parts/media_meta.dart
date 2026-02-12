part of '../playing_page.dart';

class _MediaMeta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final contentColor = colorScheme.onSurfaceVariant;

    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        final tracks = player.tracks.audio.where((e) => e.codec != null);
        if (tracks.isEmpty) return SizedBox.shrink();

        final track = tracks.first;

        // 1. 提取声道逻辑
        // 根据 media_kit 的定义，通常 track.channels 是字符串（如 "stereo"），
        // 或者 track.channelscount 是数字（如 2）
        String channelText = '';
        if (track.channels != null) {
          // 将 stereo 转为大写，或者根据声道数自定义
          channelText = track.channels!.toUpperCase();
        } else if (track.channelscount != null) {
          channelText = track.channelscount == 2
              ? 'STEREO'
              : '${track.channelscount}CH';
        }

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
          decoration: BoxDecoration(
            color: contentColor.withAlpha(10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Codec 徽章 (如 ALAC)
              _buildBadge(track.codec?.toUpperCase() ?? '-', contentColor),

              // 2. 新增：立体声徽章 (只有在获取到声道信息时显示)
              if (channelText.isNotEmpty) ...[
                const SizedBox(width: 4), // 徽章之间间距小一点
                _buildBadge(
                  _getChannelText(track.channels, track.channelscount),
                  contentColor,
                ),
              ],

              const SizedBox(width: 8),
              // 参数文字
              Text(
                effectiveText,
                style: TextStyle(
                  height: 1.0,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: contentColor.withAlpha(180),
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

  String _getChannelText(String? channels, int? count) {
    if (channels == null && count == null) return '';

    // 转换为小写进行匹配
    final c = channels?.toLowerCase() ?? '';

    if (c.contains('stereo') || count == 2) {
      return '立体声';
    } else if (c.contains('mono') || count == 1) {
      return '单声道';
    } else if (count != null && count > 2) {
      return '$count 声道'; // 例如 5.1 声道
    }
    return channels?.toUpperCase() ?? '';
  }

  // 抽离一个通用的徽章构建方法，保持 UI 一致
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          height: 1.0,
          fontSize: 10, // 徽章字体可以稍微小一点点，显得更精致
          fontWeight: FontWeight.bold,
          color: color,
        ),
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
          leadingDistribution: TextLeadingDistribution.even,
        ),
      ),
    );
  }
}
