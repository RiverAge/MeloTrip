// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allChatCoversationsHash() =>
    r'a25c88ea371c72d3afc5f774b2f9c9f0c58f890c';

/// See also [allChatCoversations].
@ProviderFor(allChatCoversations)
final allChatCoversationsProvider =
    AutoDisposeFutureProvider<List<ChatCoversation>>.internal(
      allChatCoversations,
      name: r'allChatCoversationsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allChatCoversationsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllChatCoversationsRef =
    AutoDisposeFutureProviderRef<List<ChatCoversation>>;
String _$removeChatCoversationByIdHash() =>
    r'5200c5d39a24f3a4c5bcca320c6685bcad49bb58';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [removeChatCoversationById].
@ProviderFor(removeChatCoversationById)
const removeChatCoversationByIdProvider = RemoveChatCoversationByIdFamily();

/// See also [removeChatCoversationById].
class RemoveChatCoversationByIdFamily extends Family<AsyncValue<void>> {
  /// See also [removeChatCoversationById].
  const RemoveChatCoversationByIdFamily();

  /// See also [removeChatCoversationById].
  RemoveChatCoversationByIdProvider call({required String coversationId}) {
    return RemoveChatCoversationByIdProvider(coversationId: coversationId);
  }

  @override
  RemoveChatCoversationByIdProvider getProviderOverride(
    covariant RemoveChatCoversationByIdProvider provider,
  ) {
    return call(coversationId: provider.coversationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'removeChatCoversationByIdProvider';
}

/// See also [removeChatCoversationById].
class RemoveChatCoversationByIdProvider
    extends AutoDisposeFutureProvider<void> {
  /// See also [removeChatCoversationById].
  RemoveChatCoversationByIdProvider({required String coversationId})
    : this._internal(
        (ref) => removeChatCoversationById(
          ref as RemoveChatCoversationByIdRef,
          coversationId: coversationId,
        ),
        from: removeChatCoversationByIdProvider,
        name: r'removeChatCoversationByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$removeChatCoversationByIdHash,
        dependencies: RemoveChatCoversationByIdFamily._dependencies,
        allTransitiveDependencies:
            RemoveChatCoversationByIdFamily._allTransitiveDependencies,
        coversationId: coversationId,
      );

  RemoveChatCoversationByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coversationId,
  }) : super.internal();

  final String coversationId;

  @override
  Override overrideWith(
    FutureOr<void> Function(RemoveChatCoversationByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoveChatCoversationByIdProvider._internal(
        (ref) => create(ref as RemoveChatCoversationByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coversationId: coversationId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RemoveChatCoversationByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveChatCoversationByIdProvider &&
        other.coversationId == coversationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coversationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RemoveChatCoversationByIdRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `coversationId` of this provider.
  String get coversationId;
}

class _RemoveChatCoversationByIdProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with RemoveChatCoversationByIdRef {
  _RemoveChatCoversationByIdProviderElement(super.provider);

  @override
  String get coversationId =>
      (origin as RemoveChatCoversationByIdProvider).coversationId;
}

String _$chatSessionHash() => r'a0c3e4c2f19be62a403b2c197ce1ddbf01c324bb';

/// See also [ChatSession].
@ProviderFor(ChatSession)
final chatSessionProvider =
    NotifierProvider<ChatSession, ChatCoversation>.internal(
      ChatSession.new,
      name: r'chatSessionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatSessionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChatSession = Notifier<ChatCoversation>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
