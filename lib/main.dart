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

  Future<void> _onErrorScanfoldMessage({
    required String errorMsg,
    int? statusCode,
  }) async {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
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
          home: FutureBuilder(
            future: _addListner(),
            builder:
                (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const FixedCenterCircular()
                        : const InitialPage(),
          ),
        );
      },
    );
  }
}
