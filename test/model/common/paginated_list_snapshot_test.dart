import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/paginated_list_snapshot.dart';

void main() {
  group('PaginatedListFailure', () {
    test('creates with message', () {
      const failure = PaginatedListFailure(message: 'test error');

      expect(failure.message, equals('test error'));
      expect(failure.cause, isNull);
    });

    test('creates with message and cause', () {
      const appFailure = AppFailure(
        type: AppFailureType.network,
        message: 'network error',
      );
      const failure = PaginatedListFailure(
        message: 'failed to load',
        cause: appFailure,
      );

      expect(failure.message, equals('failed to load'));
      expect(failure.cause, equals(appFailure));
    });
  });

  group('PaginatedListSnapshot', () {
    group('constructor', () {
      test('creates with default values', () {
        const snapshot = PaginatedListSnapshot<String>();

        expect(snapshot.items, isEmpty);
        expect(snapshot.isLoading, isFalse);
        expect(snapshot.hasMore, isTrue);
        expect(snapshot.offset, equals(0));
        expect(snapshot.error, isNull);
      });

      test('creates with custom values', () {
        final snapshot = PaginatedListSnapshot<int>(
          items: [1, 2, 3],
          isLoading: true,
          hasMore: false,
          offset: 10,
        );

        expect(snapshot.items, equals([1, 2, 3]));
        expect(snapshot.isLoading, isTrue);
        expect(snapshot.hasMore, isFalse);
        expect(snapshot.offset, equals(10));
      });

      test('creates with error', () {
        const failure = PaginatedListFailure(message: 'test error');
        final snapshot = PaginatedListSnapshot<String>(error: failure);

        expect(snapshot.error, equals(failure));
      });
    });

    group('copyWith', () {
      test('copies with new items', () {
        const original = PaginatedListSnapshot<String>();
        final copied = original.copyWith(items: ['a', 'b']);

        expect(copied.items, equals(['a', 'b']));
        expect(copied.isLoading, equals(original.isLoading));
        expect(copied.hasMore, equals(original.hasMore));
      });

      test('copies with new loading state', () {
        const original = PaginatedListSnapshot<String>();
        final copied = original.copyWith(isLoading: true);

        expect(copied.isLoading, isTrue);
        expect(copied.items, equals(original.items));
      });

      test('copies with new hasMore', () {
        const original = PaginatedListSnapshot<String>(hasMore: true);
        final copied = original.copyWith(hasMore: false);

        expect(copied.hasMore, isFalse);
      });

      test('copies with new offset', () {
        const original = PaginatedListSnapshot<String>();
        final copied = original.copyWith(offset: 20);

        expect(copied.offset, equals(20));
      });

      test('copies with new error', () {
        const original = PaginatedListSnapshot<String>();
        const failure = PaginatedListFailure(message: 'test error');
        final copied = original.copyWith(error: failure);

        expect(copied.error, equals(failure));
      });

      test('clears error when clearError is true', () {
        const failure = PaginatedListFailure(message: 'test error');
        const original = PaginatedListSnapshot<String>(error: failure);
        final copied = original.copyWith(clearError: true);

        expect(copied.error, isNull);
      });

      test('preserves existing error when not specified', () {
        const failure = PaginatedListFailure(message: 'test error');
        const original = PaginatedListSnapshot<String>(error: failure);
        final copied = original.copyWith(isLoading: true);

        expect(copied.error, equals(failure));
      });

      test('replaces error when new error is provided', () {
        const failure1 = PaginatedListFailure(message: 'error 1');
        const failure2 = PaginatedListFailure(message: 'error 2');
        const original = PaginatedListSnapshot<String>(error: failure1);
        final copied = original.copyWith(error: failure2);

        expect(copied.error, equals(failure2));
      });

      test('can update multiple fields at once', () {
        const original = PaginatedListSnapshot<String>();
        final copied = original.copyWith(
          items: ['x', 'y', 'z'],
          isLoading: false,
          hasMore: false,
          offset: 30,
        );

        expect(copied.items, equals(['x', 'y', 'z']));
        expect(copied.isLoading, isFalse);
        expect(copied.hasMore, isFalse);
        expect(copied.offset, equals(30));
      });
    });

    group('generic type support', () {
      test('works with int type', () {
        final snapshot = PaginatedListSnapshot<int>(items: [1, 2, 3]);
        expect(snapshot.items, equals([1, 2, 3]));
      });

      test('works with custom type', () {
        final items = [
          _TestItem(id: 1, name: 'a'),
          _TestItem(id: 2, name: 'b'),
        ];
        final snapshot = PaginatedListSnapshot<_TestItem>(items: items);
        expect(snapshot.items.length, equals(2));
        expect(snapshot.items.first.id, equals(1));
      });
    });
  });
}

class _TestItem {
  const _TestItem({required this.id, required this.name});

  final int id;
  final String name;
}
