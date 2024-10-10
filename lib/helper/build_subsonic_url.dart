part of 'index.dart';

Future<String> buildSubsonicUrl(String path, {bool withHost = false}) async {
  User user = await User.instance;
  final auth = user.auth;
  final ret =
      '${withHost ? auth?.host : ''}${path.startsWith('/') ? '' : '/'}$path${path.contains('?') ? '&' : '?'}u=${auth?.username}&t=${auth?.subsonicToken}&s=${auth?.subsonicSalt}&_=${DateTime.now().toLocal()}&f=json&v=1.8.0&c=MeloTrip';
  return ret;
}
