import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Provider naming contract', () {
    test('non-generated providers must not use *ResultProvider naming', () async {
      final providerDir = Directory('lib/provider');
      final providerFiles = providerDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !file.path.endsWith('.g.dart'))
          .toList(growable: false);

      final violations = <String>[];
      final forbiddenPattern = RegExp(r'\b\w+ResultProvider\b');

      for (final file in providerFiles) {
        final lines = await file.readAsLines();
        for (var index = 0; index < lines.length; index++) {
          final line = lines[index];
          if (!forbiddenPattern.hasMatch(line)) {
            continue;
          }
          violations.add('${file.path}:${index + 1}:${line.trim()}');
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Primary provider APIs should avoid *ResultProvider naming. Violations: ${violations.join(' | ')}',
      );
    });
  });
}
