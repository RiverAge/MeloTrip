import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routeObserverProvider = Provider<RouteObserver<PageRoute<dynamic>>>(
  (_) => RouteObserver<PageRoute<dynamic>>(),
);
