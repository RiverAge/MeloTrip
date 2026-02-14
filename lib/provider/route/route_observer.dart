import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_observer.g.dart';

@Riverpod(keepAlive: true)
RouteObserver<ModalRoute<void>> routeObserver(Ref ref) {
  return RouteObserver<ModalRoute<void>>();
}
