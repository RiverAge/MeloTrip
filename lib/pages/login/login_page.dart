import 'package:flutter/material.dart';
import 'package:melo_trip/model/auth/auth.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  _onLogin() async {
    setState(() {
      _loading = true;
    });
    final host = _hostController.text.endsWith('/')
        ? _hostController.text.substring(0, _hostController.text.length - 1)
        : _hostController.text;

    final navigator = Navigator.of(context);
    final res = await Http.post<Map<String, dynamic>>('$host/auth/login',
        data: {
          'username': _unameController.text,
          'password': _pwdController.text
        });
    final data = res?.data;
    if (data != null) {
      final auth = Auth.fromJson({...data, 'host': host});
      final u = await User.instance;
      u.update(auth);
      navigator.pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const InitialPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (_) => false);
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Spacer(
                flex: 1,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 100,
                child: Image.asset('images/navidrome.png'),
              ),
              TextField(
                controller: _hostController,
                decoration: const InputDecoration(
                    hintText: '请输入服务器地址', icon: Icon(Icons.dns_outlined)),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _unameController,
                  decoration: const InputDecoration(
                      hintText: '请输入用户名', icon: Icon(Icons.person_outline)),
                ),
              ),
              TextField(
                controller: _pwdController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: '请输入密码', icon: Icon(Icons.lock_outline)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _loading ? null : _onLogin,
                        child: _loading
                            ? const FixedCenterCircular(
                                size: 15,
                              )
                            : const Text('登录'),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
      );
}
