import 'package:melo_trip/model/common/app_failure.dart';

class PaginatedListFailure {
  const PaginatedListFailure({
    required this.message,
    this.cause,
  });

  final String message;
  final AppFailure? cause;
}

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
  final PaginatedListFailure? error;

  PaginatedListSnapshot<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    PaginatedListFailure? error,
    bool clearError = false,
  }) {
    return PaginatedListSnapshot<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
