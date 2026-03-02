import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/shared/initial/startup_navigator.dart';

class InitialPage extends ConsumerStatefulWidget {
  const InitialPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitState();
}

class _InitState extends ConsumerState<InitialPage> {
  ProviderSubscription<AsyncValue<InitialBootstrapResult>>? _bootstrapSub;
  var _navigationHandled = false;

  @override
  void initState() {
    super.initState();
    _bootstrapSub = ref.listenManual<AsyncValue<InitialBootstrapResult>>(
      initialBootstrapResultProvider,
      (_, next) {
        next.whenData(_handleBootstrapResult);
      },
      fireImmediately: true,
    );
  }

  void _handleBootstrapResult(InitialBootstrapResult result) {
    if (!mounted || _navigationHandled) return;
    _navigationHandled = true;

    final startupNavigator = ref.read(startupNavigatorProvider);
    startupNavigator.navigate(context, result);
  }

  @override
  void dispose() {
    _bootstrapSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _retryBootstrap,
                child: Text(AppLocalizations.of(context)!.retryStartup),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryBootstrap() {
    if (_navigationHandled) return;
    ref.invalidate(initialBootstrapResultProvider);
  }
}
