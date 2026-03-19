import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('providers should not call Subsonic /rest endpoints directly', () async {
    final providerDir = Directory('lib/provider');
    final providerFiles = providerDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .where((file) => !file.path.endsWith('.g.dart'))
        .toList(growable: false);

    final violations = <String>[];

    for (final file in providerFiles) {
      final normalizedPath = file.path.replaceAll('\\', '/');
      if (normalizedPath.endsWith('/provider/api/api.dart')) {
        continue;
      }

      final lines = await file.readAsLines();
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index];
        if (!line.contains('/rest/')) {
          continue;
        }
        violations.add('${file.path}:${index + 1}:${line.trim()}');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Subsonic endpoint calls should be centralized in repository layer. Violations: ${violations.join(' | ')}',
    );
  });
}
