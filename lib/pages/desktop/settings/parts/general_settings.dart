import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/provider/update/update_flow.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:update_installer/update_installer.dart';

part 'general_settings/general_settings_language_dialog.dart';
part 'general_settings/general_settings_logout_dialog.dart';
part 'general_settings/general_settings_update_helpers.dart';

class GeneralSettings extends ConsumerStatefulWidget {
  const GeneralSettings({super.key});

  @override
  ConsumerState<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends ConsumerState<GeneralSettings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeAutoCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UpdateFlowState updateState = ref.watch(updateFlowControllerProvider);
    final userConfig = ref.watch(sessionConfigProvider).value;

    final bool isReadyToInstall =
        updateState.stage == .readyToInstall &&
        updateState.pendingPackagePath != null;
    final AppUpdateInfo? availableUpdate = updateState.availableUpdate;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: <Widget>[
        Align(
          alignment: .topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                SettingSectionHeader(
                  title: l10n.settings,
                  icon: Icons.settings_suggest_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingRow(
                        label: l10n.language,
                        description: _getLanguageName(l10n, userConfig?.locale),
                        onTap: () => _showLanguageDialog(context),
                        trailing: Icon(
                          Icons.translate_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SettingRow(
                        label: l10n.checkForUpdates,
                        description: _buildUpdateSubtitle(context, updateState),
                        progress: _buildUpdateProgress(context, updateState),
                        trailing: updateState.isChecking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : (isReadyToInstall || availableUpdate != null)
                            ? FilledButton.tonal(
                                onPressed:
                                    (updateState.isChecking ||
                                        updateState.isUpdating)
                                    ? null
                                    : isReadyToInstall
                                    ? _restartAndInstallPending
                                    : availableUpdate != null
                                    ? () => _startUpdate(availableUpdate)
                                    : null,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  isReadyToInstall
                                      ? l10n.updateRestartToInstallAction
                                      : availableUpdate != null
                                      ? l10n.updateNow
                                      : '',
                                ),
                              )
                            : null,
                      ),
                      SettingRow(
                        label: l10n.logout,
                        onTap: _showLogoutConfirmDialog,
                        trailing: Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
