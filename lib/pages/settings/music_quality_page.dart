import 'package:flutter/material.dart';
import 'package:melo_trip/svc/user.dart';

class MusicQualityPage extends StatefulWidget {
  const MusicQualityPage({super.key});

  @override
  State<StatefulWidget> createState() => MusicQualityPageState();
}

class MusicQualityPageState extends State<MusicQualityPage> {
  final _list = ['16', '32', '128', '256', '0'];

  String _current = '';
  User? _user;

  @override
  void initState() {
    super.initState();
    User.instance.then((user) {
      _user = user;
      setState(() {
        _current = _user?.maxRate ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('音质'), elevation: 3),
      body: ListView.separated(
        separatorBuilder: (_, __) => const Divider(),
        itemCount: _list.length,
        itemBuilder: (contex, index) {
          return ListTile(
            title: Text(_list[index] == '0' ? '无损' : '${_list[index]}kbps'),
            subtitle: Text(['流畅', '均衡', '高清', '超清', '无损'][index]),
            trailing: _current == _list[index] ? const Icon(Icons.check) : null,
            onTap: () async {
              setState(() {
                _current = _list[index];
              });
              _user?.maxRate = _current;
            },
          );
        },
      ),
    );
  }
}
