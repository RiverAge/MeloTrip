import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics.g.dart';

@riverpod
Future<SubsonicResponse?> lyrics(Ref ref, String? songId) async {
  if (songId == null) return null;

  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/getLyricsBySongId',
    queryParameters: {'id': songId},
  );

  final data = res.data;
  if (data == null) return null;

  final response = SubsonicResponse.fromJson(data);
  final structuredLyrics =
      response.subsonicResponse?.lyricsList?.structuredLyrics;

  if (structuredLyrics == null || structuredLyrics.isEmpty) return response;

  // --- 1. 分组 (按平台后缀) ---
  final Map<String, List<StructuredLyric>> groups = {};
  for (var lyric in structuredLyrics) {
    final lang = lyric.lang ?? "";
    final source = lang.split('-').last; // 例如 NetEase
    groups.putIfAbsent(source, () => []).add(lyric);
  }

  // --- 2. 评分择优 ---
  String? bestSource;
  int maxScore = -1;

  for (var entry in groups.entries) {
    int score = 0;
    final Set<String> types = {};
    for (var item in entry.value) {
      final type =
          (item.lang ?? "").split('-').firstOrNull?.toLowerCase() ?? '';
      if (!types.contains(type)) {
        if (type.contains('ori')) {
          score += 10;
        } else if (type.contains('zho')) {
          score += 5;
        } else if (type.contains('latn')) {
          score += 2;
        }
        types.add(type);
      }
    }
    if (score > maxScore) {
      maxScore = score;
      bestSource = entry.key;
    }
  }

  final bestLyricsList = groups[bestSource] ?? [];
  if (bestLyricsList.isEmpty) return response;

  // --- 3. 排序 (决定 Line.value 数组内部的顺序) ---
  // 确保合并时，List<String> 里的第一个是原文，第二个是翻译...
  bestLyricsList.sort((a, b) {
    int getPriority(String? lang) {
      final type = (lang ?? "").toLowerCase();
      if (type.startsWith('ori')) return 0;
      if (type.startsWith('zho') || type.startsWith('trans')) return 1;
      if (type.startsWith('latn')) return 2;
      return 3;
    }

    return getPriority(a.lang).compareTo(getPriority(b.lang));
  });

  // --- 4. 执行合并 (你的核心逻辑优化版) ---
  // 使用 LinkedHashMap 保持插入顺序，或者最后对时间戳排序
  final Map<int, List<String>> mergedMap = {};

  for (var structuredLyric in bestLyricsList) {
    if (structuredLyric.line == null) continue;
    // 1. 获取类型前缀 (如 ori, zho, latn)
    final langType = (structuredLyric.lang ?? "").toLowerCase();

    // 2. 如果是罗马音(latn)，直接跳过，不进入合并逻辑
    if (langType.startsWith('latn')) {
      continue;
    }

    for (var line in structuredLyric.line ?? []) {
      final start = line.start ?? 0;
      mergedMap.putIfAbsent(start, () => []);
      mergedMap[start]?.addAll(line.value);
    }
  }

  // --- 5. 转换为最终的 Line 列表 ---
  final List<Line> finalLines = mergedMap.entries.map((entry) {
    return Line(
      start: entry.key,
      value: entry.value, // 此时这里已经是 [原文, 翻译]
    );
  }).toList();

  // 按照时间戳升序排列
  finalLines.sort((a, b) => (a.start ?? 0).compareTo(b.start ?? 0));

  // --- 6. 构造最终的不可变对象返回 ---
  // 取第一个元素作为模板（保留 displayArtist 等信息）
  final template = bestLyricsList.first;
  final finalStructuredLyric = template.copyWith(
    lang: bestSource, // 标注平台名
    line: finalLines,
  );

  return response.copyWith(
    subsonicResponse: response.subsonicResponse?.copyWith(
      lyricsList: response.subsonicResponse?.lyricsList?.copyWith(
        structuredLyrics: [finalStructuredLyric], // 只保留这一条合并后的
      ),
    ),
  );
}
