part of '../settings_page.dart';

Widget buildUpdateSubtitleWidget(
  BuildContext context,
  UpdateFlowState state,
) {
  final ThemeData theme = Theme.of(context);
  final List<Widget> children = <Widget>[
    Text(
      buildUpdateSubtitle(context, state),
      maxLines: 2,
      overflow: .ellipsis,
      // 等宽数字：百分比/字节/速度数字逐位对齐，配合 padLeft 后整行宽度
      // 恒定，下载过程中文本不再左右抖动。
      style: theme.textTheme.bodySmall?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    ),
  ];

  if (state.isUpdating && state.stage == .downloading) {
    final double? progress = state.totalBytes > 0
        ? (state.downloadProgressPercent / 100).clamp(0.0, 1.0)
        : null;
    children.add(const SizedBox(height: 8));
    children.add(
      ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          minHeight: 6,
          value: progress,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      ),
    );
  }

  return Column(
    crossAxisAlignment: .start,
    mainAxisSize: .min,
    children: children,
  );
}

String buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
  if (state.isChecking) {
    return l10n.updateCheckingInline;
  }
  if (state.stage == .verifying) {
    return l10n.updateStageVerifying;
  }
  if (state.stage == .openingInstaller) {
    return l10n.updateStageOpeningInstaller;
  }
  if (state.isUpdating) {
    // 下载中：首行版本对照（当前→新），次行进度。版本行守卫当前/新版本
    // 都已知——缺任一则只输出进度行（保持长度恒定回退，兼容旧测试）。
    final String progressLine = _buildDownloadProgressLine(state);
    final String? current = state.currentVersionName;
    final String? newName = state.availableUpdate?.versionName;
    if (current != null && newName != null) {
      return '${l10n.updateDownloadingVersion(current, newName)}\n$progressLine';
    }
    return progressLine;
  }
  if (state.checkError != null) {
    return l10n.updateCheckFailedInline;
  }
  if (state.availableUpdate case final AppUpdateInfo update) {
    // 有更新可用（未下载）：显示 当前→新 · 包大小。当前版本未知时退化为
    // 旧的"发现新版本 vX"。
    final String? current = state.currentVersionName;
    if (current != null) {
      return l10n.updateAvailableWithSize(
        current,
        update.versionName,
        formatUpdateBytes(update.fileSize),
      );
    }
    return l10n.updateAvailableInline(update.versionName);
  }
  if (state.hasChecked &&
      state.currentVersionName != null &&
      state.currentVersionCode != null) {
    return l10n.updateAlreadyLatestInline(
      state.currentVersionName!,
      state.currentVersionCode!,
    );
  }
  return l10n.checkForUpdates;
}

String formatUpdateBytes(int bytes) {
  if (bytes <= 0) return '0B';
  const double kb = 1024.0;
  const double mb = kb * 1024;
  if (bytes >= mb) {
    return '${(bytes / mb).toStringAsFixed(0)}M';
  }
  if (bytes >= kb) {
    return '${(bytes / kb).toStringAsFixed(0)}K';
  }
  return '${bytes}B';
}

/// 下载进度行：百分比 | 已下/总量 | 速度。三段固定宽度对齐，整行字符数
/// 恒定，下载过程中不左右抖动：
///  - 百分比 padLeft 到 3 位再加 "%"（"  9%" / " 12%" / "100%"）
///  - 大小段左右各自 padLeft 到同宽（"3M/25M" 这种短串也补齐）
///  - 速度段永远占槽：有速度显示 "1.2M/s"，无速度用等宽空格填齐，
///    避免 "/s" 段时有时无造成的整行宽度跳变
String _buildDownloadProgressLine(UpdateFlowState state) {
  final String percent =
      '${state.downloadProgressPercent.toStringAsFixed(0).padLeft(3)}%';
  final String downloaded = _formatUpdateBytesFixed(state.downloadedBytes);
  final String totalStr = _formatUpdateBytesFixed(state.totalBytes);
  // downloaded 左对齐补到与 totalStr 同宽，整段 "已下/总量" 宽度恒定。
  final String downloadedPadded = downloaded.padLeft(totalStr.length);
  final String size = '$downloadedPadded/$totalStr';
  final String speed = state.downloadBytesPerSecond > 0
      ? _formatUpdateSpeedFixed(state.downloadBytesPerSecond)
      : ''.padLeft(_speedSlotWidth);
  return '$percent | $size | $speed';
}

/// 速度槽固定宽度（字符数）。按 "999.9K/s" 计 = 8，覆盖百 K 量级速度
/// （小数点前 3 位 + 小数 + 单位 + "/s"）。无速度时用等宽空格填齐这一槽，
/// 避免 "/s" 段时有时无导致整行宽度跳变。
const int _speedSlotWidth = 8;

/// 字节量固定宽度格式化，与 [formatUpdateBytes] 同口径（无小数），
/// 但保证 "0B" / "3M" / "25M" 这类短串也能 padLeft 对齐。
String _formatUpdateBytesFixed(int bytes) {
  return formatUpdateBytes(bytes);
}

/// 下载速度格式化：带 1 位小数（"1.2M/s"），并 padLeft 到 [_speedSlotWidth]。
/// 带 1 位小数比整数更能反映速度变化、且不会因 1.x→2 的整数跳变而抖。
String _formatUpdateSpeedFixed(double bytesPerSecond) {
  const double kb = 1024.0;
  const double mb = kb * 1024;
  String value;
  if (bytesPerSecond >= mb) {
    value = '${(bytesPerSecond / mb).toStringAsFixed(1)}M';
  } else if (bytesPerSecond >= kb) {
    value = '${(bytesPerSecond / kb).toStringAsFixed(1)}K';
  } else {
    value = '${bytesPerSecond.toStringAsFixed(0)}B';
  }
  return '${value.padLeft(_speedSlotWidth - 2)}/s';
}
