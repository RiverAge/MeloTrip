import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/provider/app_theme_mode/app_theme_mode.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

// import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
  Http? _http;

  @override
  void initState() {
    super.initState();
    _addListner();
    _setAudioSession();
  }

  _addListner() async {
    _http = await Http.instance;
    _http?.addErrorScanfoldMessageListner(_onErrorScanfoldMessage);
  }

  _setAudioSession() {}

  @override
  void dispose() {
    super.dispose();
    _http?.removeErrorScanfoldMessageListner(_onErrorScanfoldMessage);
  }

  Future<void> _onErrorScanfoldMessage(
      {required String errorMsg, int? statusCode}) async {
    _scaffoldMessengerKey.currentState
        ?.showSnackBar(SnackBar(content: Text(errorMsg)));
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
        provider: appThemeModeProvider,
        builder: (context, data, ref) {
          return MaterialApp(
            scaffoldMessengerKey: _scaffoldMessengerKey,
            title: 'MeloTrip',
            themeMode: data,
            darkTheme: ThemeData.dark(),
            // home: Page1(),
            // home: TestPage()
            // home: LoginPage(),
            home: FutureBuilder(
                future: _addListner(),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const FixedCenterCircular()
                        : const InitialPage()),
          );
        });
  }
}

// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('page1'),
//         ),
//         body: InkWell(
//           onTap: () {
//             Navigator.of(context).push(PageRouteBuilder(
//                 opaque: false,
//                 barrierDismissible: true,
//                 pageBuilder: (BuildContext context, _, __) {
//                   return Page2();
//                 }));
//             // showModalBottomSheet(
//             //     context: context,
//             //     builder: (_) {
//             //       return Page2();
//             //     });
//             // Navigator.of(context)
//             //     .push(MaterialPageRoute(builder: (_) => Page2()));
//           },
//           child: Center(
//               child: SizedBox(
//             height: 80,
//             width: 80,
//             child: Hero(
//                 tag: 'a', child: Image.asset('images/eat_cape_town_sm.jpg')),
//           )),
//         ));
//   }
// }

// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('page2'),
//         ),
//         body: Column(children: [
//           Hero(
//             tag: 'a',
//             child: SizedBox(
//               height: 300,
//               width: 300,
//               child: Image.asset('images/eat_cape_town_sm.jpg'),
//             ),
//           )
//         ]));
//   }
// }

// class TestPage extends StatelessWidget {
//   final GlobalKey<AnimatedListState> key1 = GlobalKey<AnimatedListState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('xxx'),
//         ),
//         body: CurrentSongBuilder(builder: (_, current, songs, index, __) {
//           return AnimatedList(
//               key: key1,
//               initialItemCount: 10,
//               itemBuilder: (context, index, animation) => ListTile(
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () async {
//                       key1.currentState?.removeItem(index, (ct, animation) {
//                         return FadeTransition(
//                           opacity: CurvedAnimation(
//                             parent: animation,
//                             //让透明度变化的更快一些
//                             curve: const Interval(0.5, 1.0),
//                           ),
//                           // 不断缩小列表项的高度
//                           child: SizeTransition(
//                             sizeFactor: animation,
//                             axisAlignment: 0.0,
//                             child: ListTile(
//                               title: Text('xxxxxx'),
//                             ),
//                           ),
//                         );
//                         // return ListTile(
//                         //   title: Text('xffffffffff'),
//                         // );
//                       });
//                       final handler = await AppPlayerHandler.instance;
//                       final player = handler.player;
//                       player.removeQueueItemAt(index);
//                     },
//                   ),
//                   title: Text('xxxxxxxxxxxx')));
//         }));
//   }
// }

// class NextButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constrait) {
//       return ElevatedButton(
//         onPressed: () {
//           // var box = context.findRenderObject() as RenderBox;
//           // print('sizeobx -> ${box.size}');
//           Navigator.of(context).push(_pageRoute(context));
//         },
//         child: Text('page2'),
//       );
//     });
//   }

//   _pageRoute(BuildContext context1) {
//     var box2 = context1.findRenderObject() as RenderBox?;
//     return PageRouteBuilder(
//         transitionDuration: Duration(seconds: 13),
//         transitionsBuilder: (_, animation, secondaryAnimation, child) {
//           var windowSize = MediaQuery.of(context1).size;
//           var box = context1.findRenderObject() as RenderBox?;
//           var rect = box != null
//               ? box.localToGlobal(Offset.zero) & box.size
//               : Rect.zero;
//           var relativeRect = RelativeRect.fromSize(rect, windowSize);
//           var tween = RelativeRectTween(
//             begin: relativeRect,
//             end: RelativeRect.fill,
//           );
//           var an =
//               tween.chain(CurveTween(curve: Curves.ease)).animate(animation);
//           print('relativeRect $relativeRect');
//           // print('child ${box?.size}');
//           return Stack(
//             children: [
//               PositionedTransition(rect: an, child: child),
//             ],
//           );
//           // return Row(
//           // children: chil,
//           // );
//           // return child;
//           // return Container();
//         },
//         pageBuilder: (context, animation, secondaryAnimation) {
//           return Page2();
//         });
//   }
// }

// class Page1 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           color: Colors.redAccent,
//           child: Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(width: 130, height: 40, child: NextButton()))),
//     );
//   }
// }

// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.green,
//       child: TextButton(
//         child: Text('back'),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//     );
//   }
// }

// class FocusImageDemo extends StatelessWidget {
//   const FocusImageDemo({super.key});
//   static String routeName = 'misc/focus_image';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Focus Image')),
//       body: const Grid(),
//     );
//   }
// }

// class Grid extends StatelessWidget {
//   const Grid({super.key});
//   @override
//   Widget build(BuildContext context) {
//     // var box = context.findRenderObject() as RenderBox;
//     // print('sizeobx -> ${box.size}');
//     return Scaffold(
//       body: GridView.builder(
//         itemCount: 40,
//         gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
//         itemBuilder: (context, index) {
//           return (index >= 20)
//               ? const SmallCard(
//                   imageAssetName: 'images/eat_cape_town_sm.jpg',
//                 )
//               : const SmallCard(
//                   imageAssetName: 'images/eat__orleans_sm.jpg',
//                 );
//         },
//       ),
//     );
//   }
// }

// Route _createRoute(BuildContext parentContext, String image) {
//   return PageRouteBuilder<void>(
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return _SecondPage(image);
//     },
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       var rectAnimation = _createTween(parentContext)
//           .chain(CurveTween(curve: Curves.ease))
//           .animate(animation);

//       return Stack(
//         children: [
//           PositionedTransition(rect: rectAnimation, child: child),
//         ],
//       );
//     },
//   );
// }

// Tween<RelativeRect> _createTween(BuildContext context) {
//   var windowSize = MediaQuery.of(context).size;
//   var box = context.findRenderObject() as RenderBox;
//   var rect = box.localToGlobal(Offset.zero) & box.size;
//   var relativeRect = RelativeRect.fromSize(rect, windowSize);
//   print(
//       'windowSize $windowSize, rect ${box.size} relativeRect ${relativeRect}');

//   return RelativeRectTween(
//     begin: relativeRect,
//     end: RelativeRect.fill,
//   );
// }

// class SmallCard extends StatelessWidget {
//   const SmallCard({required this.imageAssetName, super.key});
//   final String imageAssetName;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Material(
//         child: InkWell(
//           onTap: () {
//             var nav = Navigator.of(context);
//             nav.push<void>(_createRoute(context, imageAssetName));
//           },
//           child: Image.asset(
//             imageAssetName,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SecondPage extends StatelessWidget {
//   final String imageAssetName;

//   const _SecondPage(this.imageAssetName);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Material(
//           child: InkWell(
//             onTap: () => Navigator.of(context).pop(),
//             child: AspectRatio(
//               aspectRatio: 1,
//               child: Image.asset(
//                 imageAssetName,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
