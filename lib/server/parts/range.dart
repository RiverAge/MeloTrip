part of '../cache_server.dart';

/// HTTP byte range representation for cache server.
/// Used for parsing and merging Content-Range headers.
@visibleForTesting
class Range {
  int start;
  int end;

  /// 将 Range 对象转换回 "start-end" 格式的字符串。
  @override
  String toString() {
    return '$start-$end';
  }

  Range(this.start, this.end);

  factory Range.fromString(String str) {
    final parts = str.split('-');
    if (parts.length == 2) {
      final start = int.tryParse(parts[0]) ?? 0;
      final end = int.tryParse(parts[1]) ?? 0;
      if (start < end) {
        return Range(start, end);
      } else {
        return Range(end, start);
      }
    } else {
      return Range(0, 0);
    }
  }
}

/// Merges a list of existing byte ranges with a new range.
/// Returns a sorted, non-overlapping list of merged ranges.
@visibleForTesting
List<Range> mergeRanges(List<String> oldRange, String newR) {
  final allRanges = oldRange.map((e) => Range.fromString(e)).toList();
  allRanges.add(Range.fromString(newR));

  allRanges.sort((a, b) => a.start.compareTo(b.start));

  if (allRanges.isEmpty) {
    return [];
  }

  final ret = <Range>[];
  ret.add(allRanges.first);
  if (allRanges.length == 1) {
    return ret;
  }

  for (final item in allRanges.sublist(1)) {
    final retLast = ret.last;

    if (item.start <= retLast.end + 1) {
      retLast.end = max(retLast.end, item.end);
    } else {
      ret.add(item);
    }
  }

  return ret;
}
