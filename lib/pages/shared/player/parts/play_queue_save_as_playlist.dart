part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

/// Pill button that saves the current play queue as a new playlist.
///
/// Mirrors [_PlayQueuePlaylistModeButton]: a `ConsumerWidget` constructed as
/// `const` inside the pill, reading the queue via [PlayQueueBuilder] and
/// hiding itself when the queue is empty (like [_ClearQueueButton]).
class _SaveQueueAsPlaylistButton extends StatelessWidget {
  const _SaveQueueAsPlaylistButton();

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        if (playQueue.songs.isEmpty) {
          return const SizedBox.shrink();
        }
        return IconButton(
          tooltip: AppLocalizations.of(context)!.savePlayQueueAsPlaylist,
          onPressed: () => _showSaveQueueAsPlaylistDialog(
            context,
            playQueue.songs,
          ),
          icon: const Icon(Icons.playlist_add_rounded),
        );
      },
    );
  }
}

void _showSaveQueueAsPlaylistDialog(
  BuildContext context,
  List<SongEntity> songs,
) {
  final l10n = AppLocalizations.of(context)!;
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final defaultName = l10n.savePlayQueueAsPlaylistName(date);
  showDialog<void>(
    context: context,
    builder: (dialogContext) =>
        _SaveQueueAsPlaylistDialog(defaultName: defaultName, songs: songs),
  );
}

/// Naming dialog for "save play queue as playlist". Holds a
/// [TextEditingController] so it can pre-fill and fully-select the default
/// name on open, letting the user either keep it or type to overwrite.
class _SaveQueueAsPlaylistDialog extends ConsumerStatefulWidget {
  const _SaveQueueAsPlaylistDialog({
    required this.defaultName,
    required this.songs,
  });

  final String defaultName;
  final List<SongEntity> songs;

  @override
  ConsumerState<_SaveQueueAsPlaylistDialog> createState() =>
      _SaveQueueAsPlaylistDialogState();
}

class _SaveQueueAsPlaylistDialogState
    extends ConsumerState<_SaveQueueAsPlaylistDialog> {
  late final TextEditingController _controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultName);
    // Fully select the default name on open so typing overwrites it.
    _controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.defaultName.length,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final name = _controller.text.trim().isEmpty
        ? widget.defaultName
        : _controller.text.trim();

    // Dedup by song id, drop null/empty ids.
    final songIds = widget.songs
        .map((s) => s.id)
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);

    if (songIds.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.savePlayQueueAsPlaylistEmpty)),
      );
      Navigator.of(context).pop();
      return;
    }

    setState(() => _loading = true);
    final result = await ref
        .read(playlistActionsProvider.notifier)
        .createPlaylist(name, songIds: songIds);
    if (!mounted) return;
    setState(() => _loading = false);

    if (result == null) return;
    if (result.isOk) {
      showAutoClosingSnackBar(
        messenger,
        dismissAfter: const Duration(seconds: 4),
        snackBar: SnackBar(content: Text(l10n.savePlayQueueAsPlaylistSuccess)),
      );
    } else {
      final message = resolveAppFailureMessage(l10n, failure: result.error);
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.savePlayQueueAsPlaylist),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _loading ? null : _onConfirm(),
        decoration: InputDecoration(hintText: l10n.playlistInputNameHint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: _loading ? null : _onConfirm,
          child: _loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
