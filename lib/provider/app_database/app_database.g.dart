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

String _$appDatabaseHash() => r'18bbd6be572cc04cacd48db379118c1fd3090c78';

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
