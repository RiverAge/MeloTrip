part of '../home_page.dart';

/// Skeleton placeholder for the "For You" recommendations section.
///
/// Mirrors the real layout of [_ForYouRecommendations]: a title row (with
/// trailing refresh/play affordances) plus a 180px-tall horizontal list of
/// 130-wide song cards. Keeping the same dimensions prevents layout shift
/// when real data arrives.
class _ForYouRecommendationsSkeleton extends StatelessWidget {
  const _ForYouRecommendationsSkeleton();

  static const int _cardCount = 4;
  static const double _cardWidth = 130;
  static const double _cardSpacing = 12;
  static const double _listHeight = 180;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Shimmer(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            SizedBox(
              height: _listHeight,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _cardCount,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(right: _cardSpacing),
                  child: SizedBox(
                    width: _cardWidth,
                    child: const _SongCardSkeleton(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        ShimmerBox(width: 120, height: 18, borderRadius: 4),
        ShimmerBox(width: 24, height: 24, borderRadius: 12),
      ],
    );
  }
}

class _SongCardSkeleton extends StatelessWidget {
  const _SongCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          AspectRatio(aspectRatio: 1, child: ShimmerBox(borderRadius: 8)),
          SizedBox(height: 8),
          ShimmerBox(height: 14, borderRadius: 4),
          SizedBox(height: 4),
          ShimmerBox(width: 80, height: 12, borderRadius: 4),
        ],
      ),
    );
  }
}
