part of '../tab_page.dart';

class _DesktopPlayerBar extends StatelessWidget {
  const _DesktopPlayerBar({required this.onToggleFullPlayer});

  final VoidCallback onToggleFullPlayer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      // height: 104,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
      child: AsyncValueBuilder(
        provider: appPlayerHandlerProvider,
        builder: (context, player, _) {
          return PlayQueueBuilder(
            builder: (context, playQueue, _) {
              final SongEntity? current =
                  playQueue.index < 0 ||
                      playQueue.index >= playQueue.songs.length
                  ? null
                  : playQueue.songs[playQueue.index];
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: .centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: _DesktopPlayerBarLeft(
                          current: current,
                          onToggleFullPlayer: onToggleFullPlayer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: .center,
                      child: _DesktopPlayerBarCenter(
                        player: player,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: .centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: _DesktopPlayerBarActions(
                          current: current,
                          player: player,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
