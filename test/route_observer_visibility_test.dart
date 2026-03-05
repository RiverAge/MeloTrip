import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/route/route_observer.dart';

class _RouteAwareHost extends ConsumerStatefulWidget {
  const _RouteAwareHost({super.key});

  @override
  ConsumerState<_RouteAwareHost> createState() => _RouteAwareHostState();
}

class _RouteAwareHostState extends ConsumerState<_RouteAwareHost>
    with RouteAware {
  bool visible = true;
  RouteObserver<PageRoute<dynamic>>? _observer;
  PageRoute<dynamic>? _subscribedRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    final pageRoute = route is PageRoute<dynamic> ? route : null;
    if (pageRoute == null) return;

    final observer = ref.read(routeObserverProvider);
    final shouldResubscribe =
        _observer != observer || _subscribedRoute != pageRoute;
    if (shouldResubscribe) {
      if (_observer != null && _subscribedRoute != null) {
        _observer?.unsubscribe(this);
      }
      _observer = observer;
      _subscribedRoute = pageRoute;
      _observer?.subscribe(this, pageRoute);
    }
  }

  @override
  void dispose() {
    if (_observer != null && _subscribedRoute != null) {
      _observer?.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPushNext() {
    if (!visible) return;
    setState(() {
      visible = false;
    });
  }

  @override
  void didPopNext() {
    if (visible) return;
    setState(() {
      visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: visible
          ? const SizedBox(
              key: Key('music_bar'),
              height: 40,
              child: ColoredBox(color: Colors.black),
            )
          : null,
      body: Column(
        children: [
          ElevatedButton(
            key: const Key('show_dialog'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => AlertDialog(
                  content: const Text('Dialog'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Show dialog'),
          ),
          ElevatedButton(
            key: const Key('push_page'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: ElevatedButton(
                        key: const Key('pop_page'),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Pop'),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: const Text('Push page'),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('DialogRoute does not hide the music bar', (tester) async {
    final hostKey = GlobalKey<_RouteAwareHostState>();

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final observer = ref.watch(routeObserverProvider);
            return MaterialApp(
              navigatorObservers: [observer],
              home: _RouteAwareHost(key: hostKey),
            );
          },
        ),
      ),
    );

    expect(hostKey.currentState?.visible, isTrue);
    expect(find.byKey(const Key('music_bar')), findsOneWidget);

    await tester.tap(find.byKey(const Key('show_dialog')));
    await tester.pumpAndSettle();

    expect(find.text('Dialog'), findsOneWidget);
    expect(hostKey.currentState?.visible, isTrue);
    expect(find.byKey(const Key('music_bar')), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    expect(hostKey.currentState?.visible, isTrue);
    expect(find.byKey(const Key('music_bar')), findsOneWidget);
  });

  testWidgets('PageRoute push/pop hides then restores the music bar', (
    tester,
  ) async {
    final hostKey = GlobalKey<_RouteAwareHostState>();

    await tester.pumpWidget(
      ProviderScope(
        child: Consumer(
          builder: (context, ref, _) {
            final observer = ref.watch(routeObserverProvider);
            return MaterialApp(
              navigatorObservers: [observer],
              home: _RouteAwareHost(key: hostKey),
            );
          },
        ),
      ),
    );

    expect(hostKey.currentState?.visible, isTrue);
    await tester.tap(find.byKey(const Key('push_page')));
    await tester.pumpAndSettle();

    expect(hostKey.currentState?.visible, isFalse);

    await tester.tap(find.byKey(const Key('pop_page')));
    await tester.pumpAndSettle();

    expect(hostKey.currentState?.visible, isTrue);
  });
}
