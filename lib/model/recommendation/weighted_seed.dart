import 'package:melo_trip/model/recommendation/seed_source.dart';

/// A weighted recommendation seed.
///
/// Represents a song ID with associated metadata for use in
/// recommendation seed aggregation and ranking.
///
/// Seeds are extracted from various user signals (favorites, play history,
/// ratings, etc.) and weighted to determine their influence on recommendations.
class WeightedSeed {
  const WeightedSeed({
    required this.songId,
    required this.source,
    required this.weight,
    this.reason,
    this.timestamp,
  });

  /// The song ID to use as a recommendation seed.
  ///
  /// This is a required field and should never be null or empty.
  final String songId;

  /// The source of this seed (favorite, recent, rating, etc.).
  ///
  /// This is a required field indicating where the seed came from.
  final SeedSource source;

  /// The weight of this seed in recommendation calculations.
  ///
  /// Higher weights indicate stronger user preference for this seed.
  /// Typical values: favorite=1.0, recent=0.8, current=0.7, queue=0.5.
  final double weight;

  /// Optional human-readable reason for this seed.
  ///
  /// Examples: 'favorite', 'recently_played', 'highly_rated'.
  final String? reason;

  /// Optional Unix timestamp in milliseconds.
  ///
  /// Used for time-based decay in seed ranking.
  /// Typically the time when the seed was created or last relevant.
  final int? timestamp;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightedSeed &&
          songId == other.songId &&
          source == other.source &&
          weight == other.weight &&
          reason == other.reason &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(songId, source, weight, reason, timestamp);

  @override
  String toString() {
    return 'WeightedSeed(songId: $songId, source: $source, weight: $weight, '
        'reason: $reason, timestamp: $timestamp)';
  }
}
