/// Seed source enum for recommendation seeds.
///
/// Represents different types of user signals that can be used
/// as seeds for personalized recommendations.
enum SeedSource {
  /// Favorite/starred songs.
  favorite,

  /// Songs from favorite/starred albums.
  favoriteAlbum,

  /// Songs from favorite/starred artists.
  favoriteArtist,

  /// Songs from user playlists.
  playlist,

  /// Recently played songs.
  recent,

  /// Highly rated songs.
  rating,

  /// Currently playing song.
  current,

  /// Songs in play queue.
  queue,
}
