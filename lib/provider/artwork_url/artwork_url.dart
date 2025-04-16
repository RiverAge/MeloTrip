import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:melo_trip/helper/index.dart';

part 'artwork_url.g.dart';

@riverpod
Future<String> artworkUrl(Ref ref, String id) async {
  final url = await buildSubsonicUrl('/rest/getCoverArt?id=$id', proxy: true);
  return url;
}
