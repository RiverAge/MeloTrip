import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('key page actions should not silently swallow Result errors', () async {
    final targets = <String>[
      'lib/pages/mobile/playlist/playlist_page.dart',
      'lib/pages/mobile/playlist/add_to_playlist_page.dart',
      'lib/pages/desktop/home/parts/desktop_album_card.dart',
    ];

    const silentPatterns = <String>[
      'if (result == null || result.isErr) return;',
      'if (res == null || res.isErr) return;',
      'if (result.isErr) return;',
      'if (res.isErr) return;',
    ];

    final violations = <String>[];

    for (final path in targets) {
      final content = await File(path).readAsString();
      for (final pattern in silentPatterns) {
        if (content.contains(pattern)) {
          violations.add('$path::$pattern');
        }
      }
      if (!content.contains('resolveAppFailureMessage(')) {
        violations.add('$path::missing resolveAppFailureMessage');
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Page action Result.err branches must surface mapped errors instead of silent returns. Violations: ${violations.join(' | ')}',
    );
  });
}
