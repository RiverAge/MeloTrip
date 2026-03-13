import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/persistence/app_persistence_factory_stub.dart'
    if (dart.library.io) 'package:melo_trip/persistence/app_persistence_factory_io.dart'
    if (dart.library.html) 'package:melo_trip/persistence/app_persistence_factory_web.dart'
    as impl;

abstract class AppPersistence {
  Future<AuthUser?> loadCurrentUser();

  Future<void> saveCurrentUser(AuthUser user);

  Future<void> clearCurrentUser();

  Future<Configuration?> loadUserConfig(String username);

  Future<void> saveUserConfig(Configuration configuration);

  Future<void> close();
}

Future<AppPersistence> createAppPersistence() {
  return impl.createAppPersistence();
}
