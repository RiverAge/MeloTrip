part of '../settings_page.dart';

class _ImageCache extends StatefulWidget {
  const _ImageCache();
  @override
  State<StatefulWidget> createState() => _ImageCacheState();
}

class _ImageCacheState extends State<_ImageCache> {
  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      loading: (_, __) => const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 1)),
      provider: imageCacheProvider,
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
                        await DefaultCacheManager().emptyCache();
                        ref.invalidate(imageCacheProvider);
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
