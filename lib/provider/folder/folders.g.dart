// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FolderIndexes)
final folderIndexesProvider = FolderIndexesProvider._();

final class FolderIndexesProvider
    extends $AsyncNotifierProvider<FolderIndexes, List<FolderIndexEntry>> {
  FolderIndexesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderIndexesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderIndexesHash();

  @$internal
  @override
  FolderIndexes create() => FolderIndexes();
}

String _$folderIndexesHash() => r'67283a20701e514b5949393d430a955538073db8';

abstract class _$FolderIndexes extends $AsyncNotifier<List<FolderIndexEntry>> {
  FutureOr<List<FolderIndexEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FolderIndexEntry>>, List<FolderIndexEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FolderIndexEntry>>,
                List<FolderIndexEntry>
              >,
              AsyncValue<List<FolderIndexEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FolderContents)
final folderContentsProvider = FolderContentsProvider._();

final class FolderContentsProvider
    extends $AsyncNotifierProvider<FolderContents, List<FolderIndexEntry>> {
  FolderContentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderContentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderContentsHash();

  @$internal
  @override
  FolderContents create() => FolderContents();
}

String _$folderContentsHash() => r'2e8b008e9ea26ba89138774a05e5ccdcc57a580d';

abstract class _$FolderContents extends $AsyncNotifier<List<FolderIndexEntry>> {
  FutureOr<List<FolderIndexEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<FolderIndexEntry>>, List<FolderIndexEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<FolderIndexEntry>>,
                List<FolderIndexEntry>
              >,
              AsyncValue<List<FolderIndexEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FolderPath)
final folderPathProvider = FolderPathProvider._();

final class FolderPathProvider
    extends $NotifierProvider<FolderPath, List<FolderIndexEntry>> {
  FolderPathProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderPathProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderPathHash();

  @$internal
  @override
  FolderPath create() => FolderPath();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<FolderIndexEntry> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<FolderIndexEntry>>(value),
    );
  }
}

String _$folderPathHash() => r'51e6db6b28a81a791d1bb0fb70ba2d0022fe6b09';

abstract class _$FolderPath extends $Notifier<List<FolderIndexEntry>> {
  List<FolderIndexEntry> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<List<FolderIndexEntry>, List<FolderIndexEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<FolderIndexEntry>, List<FolderIndexEntry>>,
              List<FolderIndexEntry>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ExpandedFolderIds)
final expandedFolderIdsProvider = ExpandedFolderIdsProvider._();

final class ExpandedFolderIdsProvider
    extends $NotifierProvider<ExpandedFolderIds, Set<String>> {
  ExpandedFolderIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expandedFolderIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expandedFolderIdsHash();

  @$internal
  @override
  ExpandedFolderIds create() => ExpandedFolderIds();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$expandedFolderIdsHash() => r'c1b4d8bd08a51efda1513ea40e90c555161eea86';

abstract class _$ExpandedFolderIds extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Set<String>, Set<String>>,
              Set<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FolderChildrenCache)
final folderChildrenCacheProvider = FolderChildrenCacheProvider._();

final class FolderChildrenCacheProvider
    extends
        $NotifierProvider<
          FolderChildrenCache,
          Map<String, List<FolderIndexEntry>>
        > {
  FolderChildrenCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'folderChildrenCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$folderChildrenCacheHash();

  @$internal
  @override
  FolderChildrenCache create() => FolderChildrenCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<FolderIndexEntry>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<FolderIndexEntry>>>(
        value,
      ),
    );
  }
}

String _$folderChildrenCacheHash() =>
    r'396a715d93b990d57e4f897c2bda78e867ac2c33';

abstract class _$FolderChildrenCache
    extends $Notifier<Map<String, List<FolderIndexEntry>>> {
  Map<String, List<FolderIndexEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              Map<String, List<FolderIndexEntry>>,
              Map<String, List<FolderIndexEntry>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, List<FolderIndexEntry>>,
                Map<String, List<FolderIndexEntry>>
              >,
              Map<String, List<FolderIndexEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedFolder)
final selectedFolderProvider = SelectedFolderProvider._();

final class SelectedFolderProvider
    extends $NotifierProvider<SelectedFolder, FolderIndexEntry?> {
  SelectedFolderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedFolderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedFolderHash();

  @$internal
  @override
  SelectedFolder create() => SelectedFolder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FolderIndexEntry? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FolderIndexEntry?>(value),
    );
  }
}

String _$selectedFolderHash() => r'37756fbc0ade44857def2b87216693be3bcfac08';

abstract class _$SelectedFolder extends $Notifier<FolderIndexEntry?> {
  FolderIndexEntry? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FolderIndexEntry?, FolderIndexEntry?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FolderIndexEntry?, FolderIndexEntry?>,
              FolderIndexEntry?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(FlattenedTree)
final flattenedTreeProvider = FlattenedTreeProvider._();

final class FlattenedTreeProvider
    extends
        $NotifierProvider<FlattenedTree, AsyncValue<List<TreeDisplayNode>>> {
  FlattenedTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flattenedTreeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flattenedTreeHash();

  @$internal
  @override
  FlattenedTree create() => FlattenedTree();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<TreeDisplayNode>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<TreeDisplayNode>>>(
        value,
      ),
    );
  }
}

String _$flattenedTreeHash() => r'e845ce68ede09971325d4b14ddc0e0df92171576';

abstract class _$FlattenedTree
    extends $Notifier<AsyncValue<List<TreeDisplayNode>>> {
  AsyncValue<List<TreeDisplayNode>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<TreeDisplayNode>>,
              AsyncValue<List<TreeDisplayNode>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<TreeDisplayNode>>,
                AsyncValue<List<TreeDisplayNode>>
              >,
              AsyncValue<List<TreeDisplayNode>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
