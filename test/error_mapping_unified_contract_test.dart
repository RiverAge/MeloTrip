import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app and async value builder should use shared app failure message mapper', () async {
    final appContent = await File('lib/app.dart').readAsString();
    final asyncBuilderContent =
        await File('lib/widget/provider_value_builder.dart').readAsString();

    expect(
      appContent.contains("import 'package:melo_trip/helper/app_failure_message.dart';"),
      isTrue,
    );
    expect(
      asyncBuilderContent.contains(
        "import 'package:melo_trip/helper/app_failure_message.dart';",
      ),
      isTrue,
    );
    expect(appContent.contains('resolveAppFailureMessage('), isTrue);
    expect(asyncBuilderContent.contains('resolveAppFailureMessage('), isTrue);
  });
}
