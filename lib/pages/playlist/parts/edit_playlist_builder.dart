part of '../edit_playlist_page.dart';

class _EditPlaylistBuilder extends StatefulWidget {
  const _EditPlaylistBuilder({required this.playlist});
  final PlaylistEntity playlist;

  @override
  State<StatefulWidget> createState() => _EditPlaylistBuilderState();
}

class _EditPlaylistBuilderState extends State<_EditPlaylistBuilder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  bool _isPublic = false;
  bool _enableSave = false;

  void _submitForm(WidgetRef ref) async {
    final playlistId = widget.playlist.id;
    if (playlistId == null) return;
    final res = await ref.read(playlistUpdateProvider.notifier).modify(
        playlistId: playlistId,
        name: _nameController.text,
        comment: _commentController.text,
        public: _isPublic);
    if (res?.subsonicResponse?.status == 'ok' && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _nameController.text = widget.playlist.name ?? '';
    _commentController.text = widget.playlist.comment ?? '';
    _isPublic = widget.playlist.public == true;

    setState(() {
      _enableSave = _nameController.text != '';
    });

    _nameController.addListener(_onNameChange);
    super.initState();
  }

  _onNameChange() {
    setState(() {
      _enableSave = _nameController.text != '';
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChange);
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name ?? ''),
        elevation: 3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                    hintText: '请输入歌单的名字', labelText: '名字'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration:
                    const InputDecoration(hintText: '请输入说明', labelText: '说明'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('是否公开'),
                  Checkbox(
                      value: _isPublic,
                      onChanged: (value) {
                        setState(() {
                          _isPublic = value == true;
                        });
                      }),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: AsyncValueBuilder(
                          provider: playlistUpdateProvider,
                          loading: (context, _) => const ElevatedButton(
                              onPressed: null,
                              child: FixedCenterCircular(size: 15)),
                          empty: (context, ref) => _buildLoginButton(ref),
                          builder: (context, data, ref) =>
                              _buildLoginButton(ref)),
                    ),
                  ],
                ),
              ), // Text on the button
            ],
          ),
        ),
      ),
    );
  }

  _buildLoginButton(WidgetRef ref) {
    return ElevatedButton(
      onPressed: _enableSave ? () => _submitForm(ref) : null,
      child: const Text('保存'),
    );
  }
}
