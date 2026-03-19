import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('global app error listener should not display raw AppErrorEvent.message', () async {
    final file = File('lib/app.dart');
    final content = await file.readAsString();

    expect(
      content.contains('next.message'),
      isFalse,
      reason:
          'Global error snackbar should map typed failure to localized copy, not render raw event message.',
    );
  });
}
