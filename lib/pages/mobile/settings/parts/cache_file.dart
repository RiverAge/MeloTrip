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
      loading: (_, _) => Text(AppLocalizations.of(context)!.calculating),
      provider: cachedFileSizeProvider,
      builder: (_, data, ref) {
        final int sizeInBytes = data.toInt();
        return Row(
          mainAxisSize: .min,
          children: [Text(fileSizeFormatter(sizeInBytes))],
        );
      },
    );
  }
}
