// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $AsyncNotifierProvider<AppDatabase, Database> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  AppDatabase create() => AppDatabase();
}

String _$appDatabaseHash() => r'9c025134a3e23620d2d23fc009080e45d7983529';

abstract class _$AppDatabase extends $AsyncNotifier<Database> {
  FutureOr<Database> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Database>, Database>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Database>, Database>,
              AsyncValue<Database>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
