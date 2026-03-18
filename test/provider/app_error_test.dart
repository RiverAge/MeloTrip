import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  group('AppErrorEvent', () {
    test('stores id and message', () {
      const event = AppErrorEvent(id: 42, message: 'Test error');

      expect(event.id, equals(42));
      expect(event.message, equals('Test error'));
    });
  });
}
