import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/play_queue_header.dart';
part 'parts/play_queue_controls.dart';
part 'parts/play_queue_list.dart';

enum PlayQueuePanelVariant { mobile, desktop }

double? computePlayQueueJumpOffset({
  required int index,
  required int songCount,
  required double maxScrollExtent,
  double itemExtent = 72.0,
  double edgePadding = 23.0,
}) {
  if (index < 0 || index >= songCount || !maxScrollExtent.isFinite) {
    return null;
  }
  final safeMaxOffset = (maxScrollExtent - edgePadding).clamp(
    0.0,
    double.infinity,
  );
  final targetOffset = index * itemExtent;
  return targetOffset.clamp(0.0, safeMaxOffset).toDouble();
}

class PlayQueuePanel extends ConsumerWidget {
  const PlayQueuePanel({
    super.key,
    required this.variant,
    this.onClose,
    this.closeAfterClear = false,
    this.closeOnSelection = false,
  });

  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;
  final bool closeOnSelection;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return Column(
          children: [
            _PlayQueueHeader(
              player: player,
              variant: variant,
              onClose: onClose,
              closeAfterClear: closeAfterClear,
            ),
            Expanded(
              child: PlayQueueBuilder(
                builder: (_, playQueue, _) {
                  if (playQueue.songs.isEmpty) {
                    return const NoData();
                  }
                  return _PlayQueueListView(
                    playQueue: playQueue,
                    player: player,
                    variant: variant,
                    closeOnSelection: closeOnSelection,
                  );
                },
              ),
            ),
            if (_isDesktop)
              Container(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
          ],
        );
      },
    );
  }
}