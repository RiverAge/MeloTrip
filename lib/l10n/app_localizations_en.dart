// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get listenNow => 'Listen Now';

  @override
  String get library => 'Library';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get revoke => 'Revoke';

  @override
  String get delete => 'Delete';

  @override
  String get deleted => 'Deleted';

  @override
  String get save => 'Save';

  @override
  String get name => 'Name';

  @override
  String get comment => 'Comment';

  @override
  String get language => 'Language';

  @override
  String get loginInputHostHint => 'Please Input Host Address';

  @override
  String get loginInputUserHint => 'Please Input Username';

  @override
  String get loginInputPasswordHint => 'Please Input Password';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get logoutDialogConfirm => 'Confirm Logout?';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get previousSong => 'Previous';

  @override
  String get nextSong => 'Next';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get version => 'Version';

  @override
  String get artist => 'Artist';

  @override
  String get album => 'Album';

  @override
  String get song => 'Song';

  @override
  String get songCountUnit => 'songs';

  @override
  String get albumCount => 'Album Count';

  @override
  String get systemDefault => 'System Default';

  @override
  String manyArtists(num artistCount) {
    return '... and $artistCount artists';
  }

  @override
  String get noTitle => 'No Title';

  @override
  String get endOfData => 'End Of Data';

  @override
  String get noDataFound => 'No Data';

  @override
  String get serverOnline => 'Online';

  @override
  String get serverOffline => 'Offline';

  @override
  String get serverStatus => 'Server Status';

  @override
  String get serverScaning => 'Scaning...';

  @override
  String get serverLastScanTime => 'Last Scan';

  @override
  String get serverSongCount => 'Songs Count';

  @override
  String get cachedSize => 'Cached Size';

  @override
  String get calculating => 'Calculating...';

  @override
  String get recentAdded => 'Recenty Added';

  @override
  String get randomAlbum => 'Random Album';

  @override
  String get viewAll => 'View All';

  @override
  String get rencentPlayed => 'Recently Played';

  @override
  String get mostPlayed => 'Most Played';

  @override
  String get recommendedToday => 'Recommended Today';

  @override
  String get guessYouLike => 'GuessYouLike';

  @override
  String get searchHint => 'Search for songs, artists or albums...';

  @override
  String get searchHistory => 'Search History';

  @override
  String get theme => 'Theme';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeLight => 'Light';

  @override
  String get songMetaDuration => 'Duration';

  @override
  String get songMetaFormat => 'Format';

  @override
  String get songMetaBitRate => 'Bit Rate';

  @override
  String get songMetaGenre => 'Genre';

  @override
  String get songMetaYear => 'Year';

  @override
  String get songMetaPath => 'Path';

  @override
  String get songMetaSampling => 'Sampling';

  @override
  String get songMetaTrackNumber => 'Track No';

  @override
  String get songMetaDiskNumber => 'Disk No';

  @override
  String get songMetaSize => 'Size';

  @override
  String get favorite => 'Favorite';

  @override
  String get unfavorite => 'UnFavorite';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get featureComingSoon => 'Coming soon';

  @override
  String get desktopLyrics => 'Desktop Lyrics';

  @override
  String get desktopLyricsEnabled => 'Enable floating desktop lyrics';

  @override
  String get desktopLyricsClickThrough => 'Click-through window';

  @override
  String get desktopLyricsFontSize => 'Font size';

  @override
  String get desktopLyricsOpacity => 'Opacity';

  @override
  String get desktopLyricsStrokeWidth => 'Stroke width';

  @override
  String get desktopLyricsFontWeight => 'Font weight';

  @override
  String get desktopLyricsTextColor => 'Text color';

  @override
  String get desktopLyricsShadowColor => 'Shadow color';

  @override
  String get desktopLyricsStrokeColor => 'Stroke color';

  @override
  String get desktopLyricsBackgroundColor => 'Background color';

  @override
  String get desktopLyricsBackgroundOpacity => 'Background opacity';

  @override
  String get desktopLyricsGradientEnabled => 'Enable text gradient';

  @override
  String get desktopLyricsGradientStartColor => 'Gradient start';

  @override
  String get desktopLyricsGradientEndColor => 'Gradient end';

  @override
  String get desktopLyricsTextAlign => 'Text alignment';

  @override
  String get desktopLyricsSectionText => 'Text';

  @override
  String get desktopLyricsSectionBackground => 'Background';

  @override
  String get desktopLyricsSectionGradient => 'Gradient';

  @override
  String get desktopLyricsSectionLayout => 'Layout';

  @override
  String get desktopLyricsOverlayWidth => 'Overlay width';

  @override
  String get desktopLyricsOverlayHeight => 'Overlay height';

  @override
  String get desktopLyricsAutoHeight => 'Auto height';

  @override
  String get desktopLyricsSectionPreview => 'Preview';

  @override
  String get desktopLyricsGradientOverrideHint =>
      'Text color is ignored while gradient is enabled.';

  @override
  String get desktopLyricsTokenPreview => 'Play token preview';

  @override
  String get playQueue => 'Play Queue';

  @override
  String get playNext => 'Play Next';

  @override
  String get addToPlayQueue => 'Add Queue';

  @override
  String get removeFromPlayQueue => 'Remove Queue';

  @override
  String get playQueueCleared => 'Play Queue Cleared';

  @override
  String get playlist => 'Playlist';

  @override
  String get myPlaylist => 'My Playlist';

  @override
  String get addToPlaylist => 'Add to Playlist';

  @override
  String get createNewPlaylist => 'Create New Playlist';

  @override
  String get playlistInputNameHint => 'Enter playlist name...';

  @override
  String get playlistInputCommentHint => 'Enter comment for playlist...';

  @override
  String get playlistIsPublic => 'Public';

  @override
  String playlistDeleteConfirmation(String name) {
    return 'Confirm delete  playlist $name ?';
  }

  @override
  String songHasAddedToPlaylistToast(String playlistName) {
    return 'Has been added to playlist $playlistName.';
  }

  @override
  String get musicQuality => 'Music Quality';

  @override
  String get musicQualitySmooth => 'musicQualitySmooth';

  @override
  String get musicQualityMedium => 'Medium';

  @override
  String get musicQualityHigh => 'High';

  @override
  String get musicQualityVeryHigh => 'Very High';

  @override
  String get musicQualityLossless => 'Lossless';

  @override
  String get playModeNone => 'No Repeat';

  @override
  String get playModeLoop => 'Repeat All';

  @override
  String get playModeSingle => 'Single Play';

  @override
  String get shuffleOn => 'Shuffle On';

  @override
  String get shuffleOff => 'Shuffle Off';

  @override
  String get english => 'English';

  @override
  String get simpleChinese => 'Simple Chinese';

  @override
  String get us => 'United States';

  @override
  String get cn => 'China';

  @override
  String get noLyricsFound => 'No Lyrics Found';

  @override
  String lyricsSource(String source) {
    return 'Lyrics $source';
  }

  @override
  String get albumHeaderSongs => 'Songs';

  @override
  String get albumHeaderDuration => 'Duration';

  @override
  String get albumHeaderReleaseDate => 'Release Date';

  @override
  String get retry => 'Retry';

  @override
  String get retryStartup => 'Retry startup';

  @override
  String get startupInitializing => 'Starting MeloTrip...';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get noUpdateTitle => 'No update';

  @override
  String upToDateMessage(String currentVersionName, int currentVersionCode) {
    return 'Current version $currentVersionName ($currentVersionCode) is up to date.';
  }

  @override
  String get updateAvailableTitle => 'Update available';

  @override
  String updateCurrentVersion(String versionName, int versionCode) {
    return 'Current: $versionName ($versionCode)';
  }

  @override
  String updateLatestVersion(String versionName, int versionCode) {
    return 'Latest: $versionName ($versionCode)';
  }

  @override
  String updateSizeMb(String sizeMb) {
    return 'Size: $sizeMb MB';
  }

  @override
  String get updateNow => 'Update now';

  @override
  String updateCheckFailed(String error) {
    return 'Update check failed: $error';
  }

  @override
  String get otaAndroidOnly => 'OTA update is only supported on Android';

  @override
  String get updateDownloadingPackage => 'Downloading update package...';

  @override
  String get updateStageDownloading => 'Downloading package';

  @override
  String get updateStageVerifying => 'Verifying package';

  @override
  String get updateStageOpeningInstaller => 'Opening installer';

  @override
  String updateProgressLine(String downloaded, String total, int percent) {
    return '$downloaded / $total ($percent%)';
  }

  @override
  String updateSpeedLine(String speed) {
    return 'Speed: $speed';
  }

  @override
  String updateEtaLine(String eta) {
    return 'ETA: $eta';
  }

  @override
  String get updateOpeningInstaller =>
      'Download complete. Opening installer...';

  @override
  String get updateInstallerFinished => 'Installer flow finished.';

  @override
  String get updateInstallPermissionDenied =>
      'Install permission denied. Please allow unknown app installs.';

  @override
  String updateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get encounterUnknownError => 'Encounter Unknown Error';

  @override
  String get noSongPlaying => 'No song playing';

  @override
  String get audioChannelStereo => 'STEREO';

  @override
  String get audioChannelMono => 'MONO';

  @override
  String audioChannelCount(int count) {
    return '${count}CH';
  }

  @override
  String audioSampleRateKHz(String value) {
    return '$value kHz';
  }

  @override
  String audioBitrateKbps(String value) {
    return '$value kbps';
  }

  @override
  String get playAddToNext => 'Next';

  @override
  String get playAddToLast => 'Last';

  @override
  String get track => 'Track';

  @override
  String get edit => 'Edit';

  @override
  String get folder => 'Folder';

  @override
  String get id => 'Id';

  @override
  String get title => 'Title';
}
