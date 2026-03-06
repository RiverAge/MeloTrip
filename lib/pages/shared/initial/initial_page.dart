import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  Future<void> _handleBootstrapResult(InitialBootstrapResult result) async {
    if (!mounted || _navigationHandled) return;
    _navigationHandled = true;

    final startupNavigator = ref.read(startupNavigatorProvider);
    startupNavigator.navigate(Navigator.of(context), result);
  }

  @override
  void dispose() {
    _bootstrapSub?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usesNativeSplash =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (usesNativeSplash) {
      return const Scaffold(body: SizedBox.expand());
    }
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: ColoredBox(
        color: colorScheme.surface,
        child: SafeArea(
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.music_note_rounded,
                      size: 42,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 10),
                    Text(l10n.startupInitializing),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
