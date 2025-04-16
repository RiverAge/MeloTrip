part of 'index.dart';

Future<String> buildSubsonicUrl(String path, {bool proxy = false}) async {
  User user = await User.instance;
  final auth = user.auth;
  final isStream = path.startsWith('/rest/stream');
  final ret =
      '${proxy ? proxyCacheHost : ''}${path.startsWith('/') ? '' : '/'}$path${path.contains('?') ? '&' : '?'}u=${auth?.username}&t=${auth?.subsonicToken}&s=${auth?.subsonicSalt}&_=${DateTime.now().toLocal()}&f=json&v=1.8.0&c=MeloTrip${isStream ? '&maxBitRate=${user.maxRate}' : ''}';
  return ret;
}
