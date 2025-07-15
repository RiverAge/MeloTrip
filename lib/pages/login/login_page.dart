import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _hostController.text = '';
    _unameController.text = '';
    _pwdController.text = '';
  }

  @override
  void dispose() {
    super.dispose();

    _hostController.dispose();
    _unameController.dispose();
    _pwdController.dispose();
  }

  void _onLogin() async {
    // setState(() {
    //   _loading = true;
    // });
    final host =
        _hostController.text.endsWith('/')
            ? _hostController.text.substring(0, _hostController.text.length - 1)
            : _hostController.text;

    final navigator = Navigator.of(context);
    setState(() {
      _loading = true;
    });
    final data = await ref.read(
      loginProvider(
        host: host,
        username: _unameController.text,
        password: _pwdController.text,
      ).future,
    );
    setState(() {
      _loading = false;
    });
    if (data == null) return;

    navigator.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const InitialPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (_) => false,
    );
    // final res = await Http.post<Map<String, dynamic>>(
    //   '$host/auth/login',
    //   data: {
    //     'username': _unameController.text,
    //     'password': _pwdController.text,
    //   },
    // );
    // final data = res?.data;
    // if (data != null) {
    //   final auth = Auth.fromJson({...data, 'host': host});
    //   final u = await User.instance;
    //   u.update(auth);
    //   navigator.pushAndRemoveUntil(
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation1, animation2) => const InitialPage(),
    //       transitionDuration: Duration.zero,
    //       reverseTransitionDuration: Duration.zero,
    //     ),
    //     (_) => false,
    //   );
    // } else {
    //   setState(() {
    //     _loading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Consumer(
        builder: (context, ref, _) {
          return Column(
            children: [
              const Spacer(flex: 1),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 100,
                child: Image.asset('images/navidrome.png'),
              ),
              TextField(
                controller: _hostController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.loginInputHostHint,
                  icon: const Icon(Icons.dns_outlined),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _unameController,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.loginInputPasswordHint,
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
                  hintText:
                      AppLocalizations.of(context)!.loginInputPasswordHint,
                  icon: const Icon(Icons.lock_outline),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onLogin,
                        child:
                            _loading
                                ? const FixedCenterCircular(size: 15)
                                : Text(AppLocalizations.of(context)!.login),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          );
        },
      ),
    ),
  );
}
