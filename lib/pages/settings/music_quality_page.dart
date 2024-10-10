import 'package:flutter/material.dart';

class MusicQualityPage extends StatefulWidget {
  const MusicQualityPage({super.key});

  @override
  State<StatefulWidget> createState() => MusicQualityPageState();
}

class MusicQualityPageState extends State<MusicQualityPage> {
  final _list = ['128K', '192K', '256K', '320K', '无损'];
  String _current = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('音质'), elevation: 3),
      body: ListView.separated(
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _list.length,
          itemBuilder: (contex, index) {
            return ListTile(
                title: Text(_list[index]),
                trailing:
                    _current == _list[index] ? const Icon(Icons.check) : null,
                onTap: () {
                  setState(() {
                    _current = _list[index];
                  });
                });
          }),
    );
  }
}
