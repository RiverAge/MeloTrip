part of 'folders.dart';

class FolderIndexEntry {
  const FolderIndexEntry({
    required this.id,
    required this.name,
    this.isDir = true,
    this.album,
    this.genre,
    this.year,
    this.duration,
    this.coverArt,
    this.artist,
  });

  final String id;
  final String name;
  final bool isDir;
  final String? album;
  final String? genre;
  final int? year;
  final int? duration;
  final String? coverArt;
  final String? artist;

  SongEntity toSong() {
    return SongEntity(
      id: id,
      title: name,
      album: album,
      artist: artist,
      coverArt: coverArt,
      year: year,
      duration: duration,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is FolderIndexEntry && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class TreeDisplayNode {
  const TreeDisplayNode({
    required this.entry,
    required this.depth,
    required this.isExpanded,
    required this.fullPath,
    this.isLoading = false,
  });

  final FolderIndexEntry entry;
  final int depth;
  final bool isExpanded;
  final List<FolderIndexEntry> fullPath;
  final bool isLoading;

  String get id => entry.id;
}
