/// Seed source enum for recommendation seeds.
///
/// Represents different types of user signals that can be used
/// as seeds for personalized recommendations.
enum SeedSource {
  /// Favorite/starred songs.
  favorite,

  /// Recently played songs.
  recent,

  /// Highly rated songs.
  rating,

  /// Currently playing song.
  current,

  /// Songs in play queue.
  queue,

  /// Songs from local play history.
  playHistory,
}
