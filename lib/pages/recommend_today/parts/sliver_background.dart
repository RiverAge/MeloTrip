part of '../recommend_today_page.dart';

class _SliverBackground extends StatelessWidget {
  const _SliverBackground({required this.songIds});
  final List<String?> songIds;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: ArtworkImage(
                      fit: BoxFit.cover,
                      id: songIds[0],
                    )),
                    Expanded(
                        child: ArtworkImage(
                      fit: BoxFit.cover,
                      id: songIds[1],
                    )),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: ArtworkImage(
                      fit: BoxFit.cover,
                      id: songIds[2],
                    )),
                    Expanded(
                        child: ArtworkImage(
                      fit: BoxFit.cover,
                      id: songIds[3],
                    )),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: -1,
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [
                      0,
                      0.08,
                      1
                    ],
                        colors: [
                      Color.fromRGBO(255, 255, 255, 1),
                      Color.fromRGBO(255, 255, 255, 0.5),
                      Color.fromRGBO(255, 255, 255, 0)
                    ])),
              ))
        ],
      );
}
