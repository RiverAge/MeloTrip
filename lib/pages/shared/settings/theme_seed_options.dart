import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';

class ThemeSeedOption {
  const ThemeSeedOption({required this.seed, required this.label});

  final AppThemeSeed seed;
  final String label;
}

List<ThemeSeedOption> buildThemeSeedOptions(AppLocalizations l10n) {
  return <ThemeSeedOption>[
    ThemeSeedOption(seed: AppThemeSeed.rose, label: l10n.themeColorRose),
    ThemeSeedOption(seed: AppThemeSeed.ocean, label: l10n.themeColorOcean),
    ThemeSeedOption(seed: AppThemeSeed.emerald, label: l10n.themeColorEmerald),
    ThemeSeedOption(seed: AppThemeSeed.amber, label: l10n.themeColorAmber),
    ThemeSeedOption(seed: AppThemeSeed.violet, label: l10n.themeColorViolet),
    ThemeSeedOption(seed: AppThemeSeed.teal, label: l10n.themeColorTeal),
    ThemeSeedOption(seed: AppThemeSeed.slate, label: l10n.themeColorSlate),
    ThemeSeedOption(seed: AppThemeSeed.coral, label: l10n.themeColorCoral),
  ];
}
