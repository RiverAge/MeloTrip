import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@Riverpod(keepAlive: true)
class Api extends _$Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    return dio;
  }
}
