import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/player/animated_lyrics_panel.dart';
import 'package:melo_trip/pages/shared/player/playback_media_meta_badge.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/pages/shared/player/playback_background.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/desktop_lyrics.dart';

class DesktopFullPlayerPage extends ConsumerWidget {
  const DesktopFullPlayerPage({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: PlayQueueBuilder(
        builder: (context, playQueue, _) {
          final current =
              playQueue.index < 0 || playQueue.index >= playQueue.songs.length
              ? null
              : playQueue.songs[playQueue.index];

          if (current == null) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noSongPlaying),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              PlaybackArtworkBackground(
                artworkId: 'mf-${current.id}',
                size: 2200,
                fit: .cover,
              ),
              const PlaybackBlurOverlay(
                blurSigma: 30,
                surfaceAlpha: .34,
                useVignette: true,
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: onDismiss,
                            icon: Icon(
                              Icons.expand_more_rounded,
                              size: 36,
                              color: colorScheme.onSurface,
                            ),
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).backButtonTooltip,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow =
                                constraints.maxWidth < 900 ||
                                constraints.maxHeight < 600;
                            final coverSize =
                                (constraints.biggest.shortestSide * .52)
                                    .clamp(320.0, 520.0)
                                    .toDouble();

                            return Row(
                              crossAxisAlignment: .center,
                              children: [
                                Expanded(
                                  flex: isNarrow ? 2 : 3,
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(
                                      context,
                                    ).copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minHeight: constraints.maxHeight,
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 24,
                                            ),
                                            child: Column(
                                              mainAxisAlignment: .center,
                                              crossAxisAlignment: .center,
                                              children: [
                                                Container(
                                                  width: coverSize,
                                                  height: coverSize,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                    border: Border.all(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: .12,
                                                          ),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: theme.shadowColor
                                                            .withValues(
                                                              alpha: .35,
                                                            ),
                                                        blurRadius: 24,
                                                        offset: const Offset(
                                                          0,
                                                          12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: ArtworkImage(
                                                      id: current.id,
                                                      size: 800,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 48),
                                                Text(
                                                  current.title ?? '-',
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme
                                                      .headlineMedium
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface,
                                                        fontWeight: .w900,
                                                        fontSize: isNarrow
                                                            ? 20
                                                            : 28,
                                                      ),
                                                  maxLines: 3,
                                                  overflow: .visible,
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  '${current.displayArtist ?? '-'} - ${current.album ?? '-'}',
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: colorScheme
                                                            .onSurface
                                                            .withValues(
                                                              alpha: .74,
                                                            ),
                                                        fontWeight: .w500,
                                                        fontSize: isNarrow
                                                            ? 14
                                                            : 17,
                                                      ),
                                                  maxLines: 3,
                                                  overflow: .visible,
                                                ),
                                                const SizedBox(height: 24),
                                                const PlaybackMediaMetaBadge(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isNarrow ? 40 : 100),
                                Expanded(
                                  flex: isNarrow ? 3 : 6,
                                  child: _DesktopLyrics(songId: current.id),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
