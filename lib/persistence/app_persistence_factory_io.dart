import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:melo_trip/persistence/app_persistence_sqlite.dart';

Future<AppPersistence> createAppPersistence() {
  return SqliteAppPersistence.open();
}
