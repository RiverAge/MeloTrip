import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Repository parsing contract', () {
    test(
      'repository implementations must not hand-parse Subsonic response maps',
      () async {
        final repositoryDir = Directory('lib/repository');
        final repositoryFiles = repositoryDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .toList(growable: false);

        final violations = <String>[];
        final forbiddenPatterns = <RegExp>[
          RegExp(r'\b(?:res|response)\.data\s*!?\s*\['),
          RegExp("\\[\\s*['\"]subsonic-response['\"]\\s*\\]"),
        ];

        for (final file in repositoryFiles) {
          if (file.path.endsWith('common/subsonic_response_parser.dart')) {
            continue;
          }

          final lines = await file.readAsLines();
          for (var index = 0; index < lines.length; index++) {
            final line = lines[index];
            for (final pattern in forbiddenPatterns) {
              if (!pattern.hasMatch(line)) {
                continue;
              }
              violations.add(
                '${file.path}:${index + 1}:${line.trim()}',
              );
            }
          }
        }

        expect(
          violations,
          isEmpty,
          reason:
              'Repository response parsing must use parseSubsonicResponseOrThrow. Violations: ${violations.join(' | ')}',
        );
      },
    );
  });
}
