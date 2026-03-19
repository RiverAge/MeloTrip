import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/provider/app/error.dart';

void main() {
  group('AppErrorNotifier', () {
    test('initial state is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = container.read(appErrorProvider);

      expect(result, isNull);
    });

    test('emit creates error event with message', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appErrorProvider.notifier).emit('Test error');

      final result = container.read(appErrorProvider);
      expect(result, isNotNull);
      expect(result?.message, equals('Test error'));
      expect(result?.id, equals(1));
      expect(result?.failureType, isNull);
    });

    test('emit increments id for each error', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appErrorProvider.notifier).emit('Error 1');
      container.read(appErrorProvider.notifier).emit('Error 2');

      final result1 = container.read(appErrorProvider);
      expect(result1?.id, equals(2));

      container.read(appErrorProvider.notifier).emit('Error 3');
      final result2 = container.read(appErrorProvider);
      expect(result2?.id, equals(3));
    });

    test('emit ignores empty message', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appErrorProvider.notifier).emit('');

      final result = container.read(appErrorProvider);
      expect(result, isNull);
    });

    test('emit preserves state when called multiple times', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appErrorProvider.notifier).emit('First');
      container.read(appErrorProvider.notifier).emit('Second');

      final result = container.read(appErrorProvider);
      expect(result?.message, equals('Second'));
    });

    test('emit stores failure type when provided', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(appErrorProvider.notifier)
          .emit('Network failed', failureType: AppFailureType.network);

      final result = container.read(appErrorProvider);
      expect(result?.failureType, AppFailureType.network);
    });

    test('emitFailure stores failure observability fields', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(appErrorProvider.notifier)
          .emitFailure(
            const AppFailure(
              type: AppFailureType.server,
              message: 'server failed',
              endpoint: '/rest/getArtists',
              requestId: 'req-123',
            ),
          );

      final result = container.read(appErrorProvider);
      expect(result?.failureType, AppFailureType.server);
      expect(result?.endpoint, '/rest/getArtists');
      expect(result?.requestId, 'req-123');
    });
  });

  group('AppErrorEvent', () {
    test('stores id, message and failure type', () {
      const event = AppErrorEvent(
        id: 42,
        message: 'Test error',
        failureType: AppFailureType.server,
        endpoint: '/rest/getSong',
        requestId: 'req-abc',
      );

      expect(event.id, equals(42));
      expect(event.message, equals('Test error'));
      expect(event.failureType, AppFailureType.server);
      expect(event.endpoint, '/rest/getSong');
      expect(event.requestId, 'req-abc');
    });
  });
}
