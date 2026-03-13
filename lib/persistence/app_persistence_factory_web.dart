import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:melo_trip/persistence/app_persistence_web.dart';

Future<AppPersistence> createAppPersistence() async {
  return WebAppPersistence();
}
