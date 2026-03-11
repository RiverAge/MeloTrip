import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  static const _desktopBreakpoint = 900.0;
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _hostController.text = 'https://music.587626.xyz';
    _unameController.text = 'admin';
    _pwdController.text = 'admin';
  }

  @override
  void dispose() {
    super.dispose();

    _hostController.dispose();
    _unameController.dispose();
    _pwdController.dispose();
  }

  void _onLogin() async {
    final host = _hostController.text.endsWith('/')
        ? _hostController.text.substring(0, _hostController.text.length - 1)
        : _hostController.text;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() {
      _loading = true;
    });
    try {
      final data = await ref.read(
        loginProvider(
          host: host,
          username: _unameController.text,
          password: _pwdController.text,
        ).future,
      );
      if (!mounted) return;
      if (data == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.unknownError)),
        );
        return;
      }

      ref.invalidate(currentUserProvider);
      ref.invalidate(userConfigProvider);
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const InitialPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            errorMsg.isEmpty
                ? AppLocalizations.of(context)!.unknownError
                : errorMsg,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.surfaceContainerHigh,
                  colorScheme.surface,
                  colorScheme.surfaceBright,
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 48 : 24,
                    vertical: 24,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 1040 : 420,
                    ),
                    child: isDesktop
                        ? _buildDesktopLoginShell(context)
                        : _buildMobileLoginShell(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopLoginShell(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 44, 20, 44),
              child: _buildDesktopHero(context),
            ),
          ),
          Container(
            width: 1,
            height: 420,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 44, 40, 44),
              child: _buildLoginForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopHero(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              width: 96,
              height: 96,
              child: Image.asset('images/navidrome.png'),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.login,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _hostController.text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildMobileLoginShell(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
        child: _buildLoginForm(context),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: 96,
          child: Image.asset('images/navidrome.png'),
        ),
        TextField(
          controller: _hostController,
          decoration: InputDecoration(
            hintText: l10n.loginInputHostHint,
            icon: const Icon(Icons.dns_outlined),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: _unameController,
            decoration: InputDecoration(
              hintText: l10n.loginInputUserHint,
              icon: const Icon(Icons.person_outline),
            ),
          ),
        ),
        TextField(
          controller: _pwdController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: _loading ? null : (_) => _onLogin(),
          decoration: InputDecoration(
            hintText: l10n.loginInputPasswordHint,
            icon: const Icon(Icons.lock_outline),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 32),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : _onLogin,
                  child: _loading
                      ? const FixedCenterCircular(size: 15)
                      : Text(l10n.login),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
