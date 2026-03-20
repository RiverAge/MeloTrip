import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
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
      final data = await ref.read(userSessionProvider.notifier).login(
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
        _buildTextField(
          controller: _hostController,
          hint: l10n.loginInputHostHint,
          icon: Icons.dns_rounded,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _unameController,
          hint: l10n.loginInputUserHint,
          icon: Icons.person_rounded,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _pwdController,
          hint: l10n.loginInputPasswordHint,
          icon: Icons.lock_rounded,
          obscureText: true,
          action: TextInputAction.done,
          onSubmitted: _loading ? null : (_) => _onLogin(),
        ),
        const SizedBox(height: 32),
        _buildLoginButton(context, l10n),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputAction action = TextInputAction.next,
    void Function(String)? onSubmitted,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: action,
      onSubmitted: onSubmitted,
      style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: colorScheme.surface.withValues(alpha: 0.7),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.28),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.95),
            colorScheme.primary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _loading ? null : _onLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onPrimary,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _loading
            ? FixedCenterCircular(size: 20, color: colorScheme.onPrimary)
            : Text(
                l10n.login,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLow,
            Color.lerp(colorScheme.surface, colorScheme.primary, 0.05)!,
            colorScheme.surfaceContainerHigh,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _GlowShape(
              size: 400,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _GlowShape(
              size: 300,
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            top: 200,
            left: 100,
            child: _GlowShape(
              size: 150,
              color: colorScheme.secondary.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowShape extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowShape({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
