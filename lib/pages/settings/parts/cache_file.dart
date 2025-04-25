part of '../settings_page.dart';

class _CacheFile extends StatefulWidget {
  const _CacheFile();
  @override
  State<StatefulWidget> createState() => _CacheFileState();
}

class _CacheFileState extends State<_CacheFile> {
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      loading: (_, __) => Text('计算中...'),
      provider: cachedFileSizeProvider,
      builder: (_, data, ref) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('${(data / 1024 / 1024).toInt()}M')],
        );
      },
    );
  }
}
