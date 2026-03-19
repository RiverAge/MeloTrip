import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'pages should not duplicate Result error branching inside AsyncValueBuilder builders',
    () async {
      final pagesDir = Directory('lib/pages');
      final pageFiles = pagesDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList(growable: false);

      final violations = <String>[];

      for (final file in pageFiles) {
        final lines = await file.readAsLines();
        var index = 0;
        while (index < lines.length) {
          final line = lines[index];
          if (!line.contains('AsyncValueBuilder(')) {
            index += 1;
            continue;
          }

          var depth = _parenDelta(line);
          var cursor = index + 1;
          while (cursor < lines.length && depth > 0) {
            final current = lines[cursor];
            if (current.contains('if (result.isErr)')) {
              violations.add('${file.path}:${cursor + 1}:${current.trim()}');
            }
            depth += _parenDelta(current);
            cursor += 1;
          }
          index = cursor;
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Use centralized AsyncValueBuilder error mapping instead of page-local Result error branches. Violations: ${violations.join(' | ')}',
      );
    },
  );
}

int _parenDelta(String value) {
  var delta = 0;
  for (final codeUnit in value.codeUnits) {
    if (codeUnit == 40) {
      delta += 1;
    } else if (codeUnit == 41) {
      delta -= 1;
    }
  }
  return delta;
}
