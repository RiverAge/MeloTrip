import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';

class AddPlaylistPage extends StatefulWidget {
  const AddPlaylistPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPlaylistPageState();
}

class _AddPlaylistPageState extends State<AddPlaylistPage> {
  final _controller = TextEditingController();

  var _loading = false;

  @override
  void initState() {
    _controller.addListener(_onTextChange);
    super.initState();
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _onAdd(WidgetRef ref) {
    setState(() {
      _loading = true;
    });

    setState(() {
      _loading = false;
    });
    // final playlist = res?.data?['subsonic-response']['playlist'];
    // if (playlist != null) {
    //   ref.invalidate(playlistProvider);
    //   if (!mounted) return;
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text(AppLocalizations.of(context)!.createNewPlaylist),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Spacer(flex: 1),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.playlistInputNameHint,
              ),
            ),
            const SizedBox(height: 30),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed:
                      _controller.text.isEmpty || _loading
                          ? null
                          : () => _onAdd(ref),
                  child:
                      _loading
                          ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          )
                          : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(AppLocalizations.of(context)!.confirm),
                          ),
                );
              },
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
