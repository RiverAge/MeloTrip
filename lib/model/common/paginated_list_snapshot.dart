class PaginatedListSnapshot<T> {
  const PaginatedListSnapshot({
    this.items = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
    this.error,
  });

  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final int offset;
  final Object? error;

  PaginatedListSnapshot<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    Object? error = _sentinel,
  }) {
    return PaginatedListSnapshot<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      error: identical(error, _sentinel) ? this.error : error,
    );
  }
}

const Object _sentinel = Object();
