import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/settings/settings_page.dart';
import 'package:melo_trip/provider/update/update_flow.dart';

/// 下载进度文本在进度推进/速度波动时不应左右抖动。抖动的根因是文本宽度
/// 跳变（百分比位数变化、"/s" 段时有时无、速度数字忽大忽小）。这里通过
/// 构造一组覆盖典型波动的 UpdateFlowState，断言 buildUpdateSubtitle 输出
/// 字符串的长度在整段下载过程中恒定——长度恒定是"不抖"的必要条件。
void main() {
  testWidgets(
    'download subtitle keeps constant width across progress/speed changes',
    (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      final BuildContext context = capturedContext;

      // 覆盖下载全程的典型波动：百分比 9→10→99→100（位数跳变）、
      // 速度 0/带小数/整数跳变、"/s" 段从无到有。
      final states = <UpdateFlowState>[
        const UpdateFlowState(
          isUpdating: true,
          stage: UpdateUiStage.downloading,
          downloadProgressPercent: 9,
          downloadedBytes: 2250000,
          totalBytes: 25000000,
          downloadBytesPerSecond: 0,
        ),
        const UpdateFlowState(
          isUpdating: true,
          stage: UpdateUiStage.downloading,
          downloadProgressPercent: 10,
          downloadedBytes: 2500000,
          totalBytes: 25000000,
          downloadBytesPerSecond: 1234567,
        ),
        const UpdateFlowState(
          isUpdating: true,
          stage: UpdateUiStage.downloading,
          downloadProgressPercent: 42,
          downloadedBytes: 10500000,
          totalBytes: 25000000,
          downloadBytesPerSecond: 987654,
        ),
        const UpdateFlowState(
          isUpdating: true,
          stage: UpdateUiStage.downloading,
          downloadProgressPercent: 99,
          downloadedBytes: 24750000,
          totalBytes: 25000000,
          downloadBytesPerSecond: 2048576,
        ),
        const UpdateFlowState(
          isUpdating: true,
          stage: UpdateUiStage.downloading,
          downloadProgressPercent: 100,
          downloadedBytes: 25000000,
          totalBytes: 25000000,
          downloadBytesPerSecond: 0,
        ),
      ];

      final subtitles =
          states
              .map((s) => buildUpdateSubtitle(context, s))
              .toList(growable: false);

      // 调试用：打印实际输出，便于人工核对格式。
      // ignore: avoid_print
      for (final s in subtitles) {
        // ignore: avoid_print
        print('subtitle: "$s" (len=${s.length})');
      }

      final int expectedLength = subtitles.first.length;
      for (int i = 0; i < subtitles.length; i++) {
        expect(
          subtitles[i].length,
          expectedLength,
          reason:
              'subtitle width changed at state #$i: '
              '"${subtitles[i]}" (len=${subtitles[i].length}) != '
              '"${subtitles.first}" (len=$expectedLength)',
        );
      }

      // 速度槽在无速度时也应占满等宽空格，不能缩短整行。
      final noSpeedSubtitle = subtitles.first; // downloadBytesPerSecond: 0
      expect(noSpeedSubtitle.endsWith('/s'), isFalse);
      expect(noSpeedSubtitle.contains('|'), isTrue);
      // 无速度那行末尾应是占位空格而非被截断的 "/s" 段。
      final speedSlot = noSpeedSubtitle.split(' | ').last;
      expect(speedSlot.trim(), isEmpty);
    },
  );
}
