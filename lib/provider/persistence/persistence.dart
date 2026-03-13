import 'dart:async';

import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persistence.g.dart';

@Riverpod(keepAlive: true)
Future<AppPersistence> appPersistence(Ref ref) async {
  final persistence = await createAppPersistence();
  ref.onDispose(() {
    unawaited(persistence.close());
  });
  return persistence;
}
