import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

part 'parts/login_background.dart';
part 'parts/login_form_controls.dart';

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
    _hostController.dispose();
    _unameController.dispose();
    _pwdController.dispose();
    super.dispose();
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
      final data = await ref
          .read(userSessionProvider.notifier)
          .login(
            host: host,
            username: _unameController.text,
            password: _pwdController.text,
          );
      if (!mounted) return;
      if (data == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.unknownError)),
        );
        return;
      }

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
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
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
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient and Shapes
          const _LoginBackground(),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= _desktopBreakpoint;
                return Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                      vertical: 24,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isDesktop ? 900 : 420,
                      ),
                      child: isDesktop
                          ? _buildDesktopLoginShell(context)
                          : _buildMobileLoginShell(context),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLoginShell(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: _buildHero(context),
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: _buildLoginForm(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLoginShell(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 14),
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHero(context, compact: true),
          const SizedBox(height: 32),
          _buildLoginForm(context),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, {bool compact = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: compact
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: compact ? 96 : 128,
          height: compact ? 96 : 128,
          child: Image.asset('images/navidrome.png'),
        ),
        SizedBox(height: compact ? 24 : 32),
        Wrap(
          alignment: compact ? WrapAlignment.center : WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withValues(alpha: 0.8),
                ],
              ).createShader(bounds),
              child: Text(
                'MeloTrip',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  fontSize: compact ? 30 : 42,
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 24,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            Text(
              AppLocalizations.of(context)!.login,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LoginTextField(
          controller: _hostController,
          hint: l10n.loginInputHostHint,
          icon: Icons.dns_rounded,
        ),
        const SizedBox(height: 16),
        _LoginTextField(
          controller: _unameController,
          hint: l10n.loginInputUserHint,
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 16),
        _LoginTextField(
          controller: _pwdController,
          hint: l10n.loginInputPasswordHint,
          icon: Icons.lock_rounded,
          obscureText: true,
          action: TextInputAction.done,
          onSubmitted: _loading ? null : (_) => _onLogin(),
        ),
        const SizedBox(height: 32),
        _LoginButton(loading: _loading, label: l10n.login, onPressed: _onLogin),
      ],
    );
  }
}
