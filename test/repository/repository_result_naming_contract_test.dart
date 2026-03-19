import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repository Result naming contract', () {
    test('Result-returning repository methods must be try-prefixed', () async {
      final repositoryDir = Directory('lib/repository');
      final repositoryFiles = repositoryDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList(growable: false);

      final violations = <String>[];
      final resultMethodPattern = RegExp(
        r'Future<Result<[^>]+>>\s+([a-zA-Z_]\w*)\s*\(',
      );

      for (final file in repositoryFiles) {
        if (file.path.endsWith('common/repository_guard.dart')) {
          continue;
        }

        final content = await file.readAsString();
        final matches = resultMethodPattern.allMatches(content);

        for (final match in matches) {
          final methodName = match.group(1);
          if (methodName == null) continue;
          if (!methodName.startsWith('try')) {
            violations.add('${file.path}:$methodName');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Repository Result API names must use try* prefix. Violations: ${violations.join(', ')}',
      );
    });
  });
}
