import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/favorite/favorite_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/playlist/playlist_page.dart';
import 'package:melo_trip/pages/settings/app_theme_page.dart';
import 'package:melo_trip/pages/settings/language_page.dart';
import 'package:melo_trip/pages/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/cache_file.dart';
part 'parts/server_status.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        elevation: 3.0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
        children: [
          _ServerStatus(),
          Card(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => AppThemePage()));
                  },
                  leading: Icon(Icons.contrast),
                  title: Text(AppLocalizations.of(context)!.theme),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: Text(AppLocalizations.of(context)!.musicQuality),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: ((_) => MusicQualityPage())),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.featured_play_list_outlined),
                  title: Text(AppLocalizations.of(context)!.myPlaylist),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const PlaylistPage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: Text(AppLocalizations.of(context)!.myFavorites),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const FavoritePage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(AppLocalizations.of(context)!.language),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((_) => const LanguagePage()),
                        ),
                      ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            label: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _onLogout() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.logout),
            content: Text(AppLocalizations.of(context)!.logoutDialogConfirm),
            actions: <Widget>[
              TextButton(
                child: Text(AppLocalizations.of(context)!.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
              AsyncValueBuilder(
                provider: appPlayerHandlerProvider,
                builder: (context, player, _) {
                  return Consumer(
                    builder: (context, ref, _) {
                      return TextButton(
                        child: Text(AppLocalizations.of(context)!.confirm),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await player.pause();
                          await ref.read(logoutProvider.future);
                          navigator.pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, _, _) => const InitialPage(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
    );
  }
}
