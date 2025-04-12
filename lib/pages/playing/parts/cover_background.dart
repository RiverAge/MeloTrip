part of '../playing_page.dart';

class _CoverBackground extends StatelessWidget {
  const _CoverBackground();
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: CurrentSongBuilder(
      builder: (context, current, songs, index, ref) {
        return ArtworkImage(fit: BoxFit.cover, id: 'mf-${current?.id}');
      },
    ),
  );
}
