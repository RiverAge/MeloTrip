part of '../settings_page.dart';

class _StreamCache extends StatefulWidget {
  const _StreamCache();
  @override
  State<StatefulWidget> createState() => _StreamCacheState();
}

class _StreamCacheState extends State<_StreamCache> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      loading: (_, __) => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 1)),
      provider: streamCacheProvider,
      builder: (_, data, ref) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${(data / 1024 / 1024).toInt()}M'),
            TextButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() {
                          _loading = true;
                        });
                        await AudioPlayer.clearAssetCache();
                        ref.invalidate(streamCacheProvider);

                        setState(() {
                          _loading = false;
                        });
                      },
                child: _loading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 1))
                    : const Text('清理'))
          ],
        );
      },
    );
  }
}
