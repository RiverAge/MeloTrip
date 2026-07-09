import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';

/// 选择一条 [StructuredLyric] 用于展示。
///
/// 选择优先级：
/// 1. `kind == main`（无 enhanced 时 kind 缺失，视为 main）且含逐字 `cueLine`；
/// 2. `kind == main`；
/// 3. 任意第一条。
///
/// 翻译/注音（translation/pronunciation）作为后续条目保留在
/// `structuredLyrics` 中，供 UI 可选叠显，数据不丢弃。
SubsonicResponse mergePreferredStructuredLyrics(SubsonicResponse response) {
  final all = response.subsonicResponse?.lyricsList?.structuredLyrics;
  if (all == null || all.isEmpty) return response;

  bool isMain(StructuredLyric s) {
    final kind = s.kind;
    return kind == null || kind == '' || kind == 'main';
  }

  StructuredLyric? pick(bool Function(StructuredLyric) test) {
    for (final s in all) {
      if (test(s)) return s;
    }
    return null;
  }

  final chosen = pick((s) => isMain(s) && (s.cueLine?.isNotEmpty ?? false)) ??
      pick((s) => isMain(s)) ??
      all.first;

  // chosen 置首，其余按原序保留
  final ordered = <StructuredLyric>[
    chosen,
    ...all.where((s) => !identical(s, chosen)),
  ];

  return response.copyWith(
    subsonicResponse: response.subsonicResponse?.copyWith(
      lyricsList: response.subsonicResponse?.lyricsList?.copyWith(
        structuredLyrics: ordered,
      ),
    ),
  );
}
