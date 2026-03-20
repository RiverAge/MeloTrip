part of '../general_settings.dart';

extension _GeneralSettingsLogoutDialog on _GeneralSettingsState {
  void _showLogoutConfirmDialog() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutDialogConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _logout();
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    final NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player != null) {
      await player.pause();
    }
    await ref.read(userSessionProvider.notifier).logout();
    if (!mounted) return;
    navigator.pushAndRemoveUntil(
      PageRouteBuilder<void>(
        pageBuilder: (BuildContext context, _, _) => const InitialPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (Route<Object?> route) => false,
    );
  }
}
