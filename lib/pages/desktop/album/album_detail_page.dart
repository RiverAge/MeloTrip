import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/album_detail_header.dart';
part 'parts/album_detail_track_sections.dart';
part 'parts/album_detail_widgets.dart';

class DesktopAlbumDetailPage extends ConsumerWidget {
  const DesktopAlbumDetailPage({super.key, required this.albumId});

  final String? albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AsyncValueBuilder(
        provider: albumDetailProvider(albumId),
        builder: (context, data, ref) {
          final AlbumEntity? album = data.subsonicResponse?.album;
          final List<SongEntity> songs = album?.song ?? <SongEntity>[];
          if (album == null) {
            return const NoData();
          }

          return _AlbumDetailContent(album: album, songs: songs);
        },
      ),
    );
  }
}

class _AlbumDetailContent extends StatefulWidget {
  const _AlbumDetailContent({required this.album, required this.songs});

  final AlbumEntity album;
  final List<SongEntity> songs;

  @override
  State<_AlbumDetailContent> createState() => _AlbumDetailContentState();
}

class _AlbumDetailContentState extends State<_AlbumDetailContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 240 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset <= 240 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _AlbumDetailHeader(
          album: widget.album,
          songs: widget.songs,
          showTitle: _showTitle,
          onPlayAlbum: (WidgetRef ref) => _playAlbum(ref, widget.songs),
          formatTotalDuration: _formatTotalDuration,
        ),
        const _AlbumTrackListToolbar(),
        _AlbumTrackList(songs: widget.songs, onPlaySong: _playSong),
        const _AlbumRecommendationsSection(),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Future<void> _playSong(WidgetRef ref, SongEntity song) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return;
    }
    await player.insertAndPlay(song);
  }

  Future<void> _playAlbum(WidgetRef ref, List<SongEntity> songs) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return;
    }
    await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player.play();
  }

  String _formatTotalDuration(List<SongEntity> songs) {
    final int totalSec = songs.fold<int>(
      0,
      (int sum, SongEntity song) => sum + (song.duration ?? 0),
    );
    final int min = totalSec ~/ 60;
    final int sec = totalSec % 60;
    return '$min:$sec';
  }
}
