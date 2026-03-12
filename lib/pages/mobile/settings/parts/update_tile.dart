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
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodySmall,
    ),
  ];

  if (state.isUpdating && state.stage == UpdateUiStage.downloading) {
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
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: children,
  );
}

String buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
  final AppLocalizations l10n = AppLocalizations.of(context)!;
  if (state.isChecking) {
    return l10n.updateCheckingInline;
  }
  if (state.stage == UpdateUiStage.verifying) {
    return l10n.updateStageVerifying;
  }
  if (state.stage == UpdateUiStage.openingInstaller) {
    return l10n.updateStageOpeningInstaller;
  }
  if (state.isUpdating) {
    final String percent = '${state.downloadProgressPercent.toStringAsFixed(0)}%';
    final String size =
        '${formatUpdateBytes(state.downloadedBytes)}/${formatUpdateBytes(state.totalBytes)}';
    final String speed = state.downloadBytesPerSecond > 0
        ? '${formatUpdateBytes(state.downloadBytesPerSecond.round())}/s'
        : '';
    final List<String> parts = <String>[percent, size, speed]
      ..removeWhere((String item) => item.isEmpty);
    return parts.join(' | ');
  }
  if (state.checkError != null) {
    return l10n.updateCheckFailedInline;
  }
  if (state.availableUpdate case final AppUpdateInfo update) {
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
