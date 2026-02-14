import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MediaKit.ensureInitialized();

  // 这是关键的初始化步骤
  if (Platform.isWindows || Platform.isLinux) {
    // 初始化用于 Windows/Linux 的 FFI 版本
    sqfliteFfiInit();
    // 将默认的数据库工厂更改为 FFI 版本
    databaseFactory = databaseFactoryFfi;
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}
