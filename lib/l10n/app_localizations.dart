import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN'),
  ];

  /// Tabbar Settings text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Tabbar Listen Now text
  ///
  /// In en, this message translates to:
  /// **'Listen Now'**
  String get listenNow;

  /// Tabbar Library text
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// Home breadcrumb or button text
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Text for confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Text for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Text for revoke
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// Text for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Text for deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// Text for save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Text for name field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Text for comment field
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// language of app
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Hint text for host address input field of login page
  ///
  /// In en, this message translates to:
  /// **'Please Input Host Address'**
  String get loginInputHostHint;

  /// Hint text for username input field of login page
  ///
  /// In en, this message translates to:
  /// **'Please Input Username'**
  String get loginInputUserHint;

  /// Hint text for password input field of login page
  ///
  /// In en, this message translates to:
  /// **'Please Input Password'**
  String get loginInputPasswordHint;

  /// Button text for login action
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Button text for logout action
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Text for logout dialog confirm message
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout?'**
  String get logoutDialogConfirm;

  /// Button text for play action
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Button text for pause action
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Playback label
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// Shuffle label
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get shuffle;

  /// Tooltip for previous song button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousSong;

  /// Tooltip for next song button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextSong;

  /// Text for yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Text for no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// App version text
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for artist name in song details
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// Label for album name in song details
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// Label for song name in song details
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get song;

  /// Plural unit for song count
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get songCountUnit;

  /// number of albums of artist
  ///
  /// In en, this message translates to:
  /// **'Album Count'**
  String get albumCount;

  /// System default theme option for app
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// Plural form for many artists
  ///
  /// In en, this message translates to:
  /// **'... and {artistCount} artists'**
  String manyArtists(num artistCount);

  /// Default title when no title available in notification title
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get noTitle;

  /// List end message
  ///
  /// In en, this message translates to:
  /// **'End Of Data'**
  String get endOfData;

  /// List empty message
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noDataFound;

  /// Server status text for online state
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get serverOnline;

  /// Server status text for offline state
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get serverOffline;

  /// Title of server status is OK
  ///
  /// In en, this message translates to:
  /// **'Server Status'**
  String get serverStatus;

  /// server status text for scanned state
  ///
  /// In en, this message translates to:
  /// **'Scaning...'**
  String get serverScaning;

  /// Server Last Scan Time
  ///
  /// In en, this message translates to:
  /// **'Last Scan'**
  String get serverLastScanTime;

  /// Songs Count of Server
  ///
  /// In en, this message translates to:
  /// **'Songs Count'**
  String get serverSongCount;

  /// Local Cached Size of Songs and Iamges
  ///
  /// In en, this message translates to:
  /// **'Cached Size'**
  String get cachedSize;

  /// Text to show while CacheSize calculation is in progress
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get calculating;

  /// Clear cache button label
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Clear cache success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get clearCacheSuccess;

  /// recently added songs of server
  ///
  /// In en, this message translates to:
  /// **'Recenty Added'**
  String get recentAdded;

  /// Random Album of server pushed
  ///
  /// In en, this message translates to:
  /// **'Random Album'**
  String get randomAlbum;

  /// View all button for recommended songs
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Recently Played songs of user
  ///
  /// In en, this message translates to:
  /// **'Recently Played'**
  String get rencentPlayed;

  /// Most played albums section title
  ///
  /// In en, this message translates to:
  /// **'Most Played'**
  String get mostPlayed;

  /// Title of recommended songs for today
  ///
  /// In en, this message translates to:
  /// **'Recommended Today'**
  String get recommendedToday;

  /// Title of smart suggestion
  ///
  /// In en, this message translates to:
  /// **'GuessYouLike'**
  String get guessYouLike;

  /// Search hint text for search bar
  ///
  /// In en, this message translates to:
  /// **'Search for songs, artists or albums...'**
  String get searchHint;

  /// Title of search history page
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// Theme selection for app
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark theme option for app
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Light theme option for app
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Duration of song meta data
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get songMetaDuration;

  /// songMetaFormat of song meta data
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get songMetaFormat;

  /// Bit Rate of song meta data
  ///
  /// In en, this message translates to:
  /// **'Bit Rate'**
  String get songMetaBitRate;

  /// Genre of song meta data
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get songMetaGenre;

  /// Year of song meta data
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get songMetaYear;

  /// Path of song meta data
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get songMetaPath;

  /// Sampling of song meta data
  ///
  /// In en, this message translates to:
  /// **'Sampling'**
  String get songMetaSampling;

  /// Track No of song meta data
  ///
  /// In en, this message translates to:
  /// **'Track No'**
  String get songMetaTrackNumber;

  /// Disk Number of song meta data
  ///
  /// In en, this message translates to:
  /// **'Disk No'**
  String get songMetaDiskNumber;

  /// Size of song meta data
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get songMetaSize;

  /// Favorite A song or artist or album
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// UnFavorite A song or artist or album
  ///
  /// In en, this message translates to:
  /// **'UnFavorite'**
  String get unfavorite;

  /// My Favorite songs, artists or albums
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// Tooltip and hint for desktop features not implemented yet
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get featureComingSoon;

  /// Desktop floating lyrics settings section title
  ///
  /// In en, this message translates to:
  /// **'Desktop Lyrics'**
  String get desktopLyrics;

  /// Desktop lyrics enabled switch description
  ///
  /// In en, this message translates to:
  /// **'Enable floating desktop lyrics'**
  String get desktopLyricsEnabled;

  /// Desktop lyrics click-through mode setting
  ///
  /// In en, this message translates to:
  /// **'Click-through window'**
  String get desktopLyricsClickThrough;

  /// Desktop lyrics font size setting
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get desktopLyricsFontSize;

  /// Desktop lyrics opacity setting
  ///
  /// In en, this message translates to:
  /// **'Opacity'**
  String get desktopLyricsOpacity;

  /// Desktop lyrics stroke width setting
  ///
  /// In en, this message translates to:
  /// **'Stroke width'**
  String get desktopLyricsStrokeWidth;

  /// Desktop lyrics font weight setting
  ///
  /// In en, this message translates to:
  /// **'Font weight'**
  String get desktopLyricsFontWeight;

  /// Desktop lyrics text color setting
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get desktopLyricsTextColor;

  /// Desktop lyrics shadow color setting
  ///
  /// In en, this message translates to:
  /// **'Shadow color'**
  String get desktopLyricsShadowColor;

  /// Desktop lyrics stroke color setting
  ///
  /// In en, this message translates to:
  /// **'Stroke color'**
  String get desktopLyricsStrokeColor;

  /// Desktop lyrics background color setting
  ///
  /// In en, this message translates to:
  /// **'Background color'**
  String get desktopLyricsBackgroundColor;

  /// Desktop lyrics background opacity setting
  ///
  /// In en, this message translates to:
  /// **'Background opacity'**
  String get desktopLyricsBackgroundOpacity;

  /// Desktop lyrics text gradient enable switch
  ///
  /// In en, this message translates to:
  /// **'Enable text gradient'**
  String get desktopLyricsGradientEnabled;

  /// Desktop lyrics text gradient start color
  ///
  /// In en, this message translates to:
  /// **'Gradient start'**
  String get desktopLyricsGradientStartColor;

  /// Desktop lyrics text gradient end color
  ///
  /// In en, this message translates to:
  /// **'Gradient end'**
  String get desktopLyricsGradientEndColor;

  /// Desktop lyrics text alignment label
  ///
  /// In en, this message translates to:
  /// **'Text alignment'**
  String get desktopLyricsTextAlign;

  /// Desktop lyrics text section title
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get desktopLyricsSectionText;

  /// Desktop lyrics background section title
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get desktopLyricsSectionBackground;

  /// Desktop lyrics gradient section title
  ///
  /// In en, this message translates to:
  /// **'Gradient'**
  String get desktopLyricsSectionGradient;

  /// Desktop lyrics layout section title
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get desktopLyricsSectionLayout;

  /// Desktop lyrics overlay width
  ///
  /// In en, this message translates to:
  /// **'Overlay width'**
  String get desktopLyricsOverlayWidth;

  /// Desktop lyrics overlay height
  ///
  /// In en, this message translates to:
  /// **'Overlay height'**
  String get desktopLyricsOverlayHeight;

  /// Desktop lyrics auto height switch
  ///
  /// In en, this message translates to:
  /// **'Auto height'**
  String get desktopLyricsAutoHeight;

  /// Desktop lyrics preview section title
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get desktopLyricsSectionPreview;

  /// Hint shown when text gradient overrides plain text color
  ///
  /// In en, this message translates to:
  /// **'Text color is ignored while gradient is enabled.'**
  String get desktopLyricsGradientOverrideHint;

  /// Desktop lyrics token-by-token preview action
  ///
  /// In en, this message translates to:
  /// **'Play token preview'**
  String get desktopLyricsTokenPreview;

  /// play queue
  ///
  /// In en, this message translates to:
  /// **'Play Queue'**
  String get playQueue;

  /// add this song to play queue after current song is played
  ///
  /// In en, this message translates to:
  /// **'Play Next'**
  String get playNext;

  /// Add to user play queue
  ///
  /// In en, this message translates to:
  /// **'Add Queue'**
  String get addToPlayQueue;

  /// Clear the current play queue
  ///
  /// In en, this message translates to:
  /// **'Clear Play Queue'**
  String get clearPlayQueue;

  /// Remove from user play queue
  ///
  /// In en, this message translates to:
  /// **'Remove Queue'**
  String get removeFromPlayQueue;

  /// Play Queue Cleared hint
  ///
  /// In en, this message translates to:
  /// **'Play Queue Cleared'**
  String get playQueueCleared;

  /// Playlist for app
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// My Playlist for app
  ///
  /// In en, this message translates to:
  /// **'My Playlist'**
  String get myPlaylist;

  /// Add song to user playlist
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// create new playlist
  ///
  /// In en, this message translates to:
  /// **'Create New Playlist'**
  String get createNewPlaylist;

  /// Hint text for playlist name input field
  ///
  /// In en, this message translates to:
  /// **'Enter playlist name...'**
  String get playlistInputNameHint;

  /// Hint text for playlist comment input field
  ///
  /// In en, this message translates to:
  /// **'Enter comment for playlist...'**
  String get playlistInputCommentHint;

  /// is playlist public or not
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get playlistIsPublic;

  /// Confirmation message for deleting a playlist
  ///
  /// In en, this message translates to:
  /// **'Confirm delete  playlist {name} ?'**
  String playlistDeleteConfirmation(String name);

  /// No description provided for @songHasAddedToPlaylistToast.
  ///
  /// In en, this message translates to:
  /// **'Has been added to playlist {playlistName}.'**
  String songHasAddedToPlaylistToast(String playlistName);

  /// Label for music quality settings
  ///
  /// In en, this message translates to:
  /// **'Music Quality'**
  String get musicQuality;

  /// Description of smooth music quality option
  ///
  /// In en, this message translates to:
  /// **'musicQualitySmooth'**
  String get musicQualitySmooth;

  /// Description of medium music quality option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get musicQualityMedium;

  /// Description of high music quality option
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get musicQualityHigh;

  /// Description of very high music quality option
  ///
  /// In en, this message translates to:
  /// **'Very High'**
  String get musicQualityVeryHigh;

  /// Description of lossless music quality option
  ///
  /// In en, this message translates to:
  /// **'Lossless'**
  String get musicQualityLossless;

  /// Play mode for no repeat play
  ///
  /// In en, this message translates to:
  /// **'No Repeat'**
  String get playModeNone;

  /// Play mode for repeat all play
  ///
  /// In en, this message translates to:
  /// **'Repeat All'**
  String get playModeLoop;

  /// Play mode for single song play
  ///
  /// In en, this message translates to:
  /// **'Single Play'**
  String get playModeSingle;

  /// Shuffle mode on for random play
  ///
  /// In en, this message translates to:
  /// **'Shuffle On'**
  String get shuffleOn;

  /// Shuffle mode off for normal play
  ///
  /// In en, this message translates to:
  /// **'Shuffle Off'**
  String get shuffleOff;

  /// English language
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Simple Chinese
  ///
  /// In en, this message translates to:
  /// **'Simple Chinese'**
  String get simpleChinese;

  /// United States of America
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get us;

  /// People's Republic of China
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get cn;

  /// Lyrics of Song could not be found
  ///
  /// In en, this message translates to:
  /// **'No Lyrics Found'**
  String get noLyricsFound;

  /// Lyrics source badge text
  ///
  /// In en, this message translates to:
  /// **'Lyrics {source}'**
  String lyricsSource(String source);

  /// Album header metric label for song count
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get albumHeaderSongs;

  /// Album header metric label for total duration
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get albumHeaderDuration;

  /// Album header metric label for release date
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get albumHeaderReleaseDate;

  /// Generic retry action text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Retry action text shown on startup page
  ///
  /// In en, this message translates to:
  /// **'Retry startup'**
  String get retryStartup;

  /// Status text shown while app bootstrap tasks are running
  ///
  /// In en, this message translates to:
  /// **'Starting MeloTrip...'**
  String get startupInitializing;

  /// Settings action text for checking app updates
  ///
  /// In en, this message translates to:
  /// **'Check for updates'**
  String get checkForUpdates;

  /// Dialog title shown when app is already latest
  ///
  /// In en, this message translates to:
  /// **'No update'**
  String get noUpdateTitle;

  /// Dialog content shown when app is already latest
  ///
  /// In en, this message translates to:
  /// **'Current version {currentVersionName} ({currentVersionCode}) is up to date.'**
  String upToDateMessage(String currentVersionName, int currentVersionCode);

  /// Dialog title when a newer version is available
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailableTitle;

  /// Current app version line in update dialog
  ///
  /// In en, this message translates to:
  /// **'Current: {versionName} ({versionCode})'**
  String updateCurrentVersion(String versionName, int versionCode);

  /// Latest app version line in update dialog
  ///
  /// In en, this message translates to:
  /// **'Latest: {versionName} ({versionCode})'**
  String updateLatestVersion(String versionName, int versionCode);

  /// Update package size in MB
  ///
  /// In en, this message translates to:
  /// **'Size: {sizeMb} MB'**
  String updateSizeMb(String sizeMb);

  /// Button text to start OTA update
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// Snackbar text when update check request fails
  ///
  /// In en, this message translates to:
  /// **'Update check failed: {error}'**
  String updateCheckFailed(String error);

  /// Inline status shown while the settings page checks for updates
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get updateCheckingInline;

  /// Inline status shown when a new update is available in settings
  ///
  /// In en, this message translates to:
  /// **'New version v{versionName} is available'**
  String updateAvailableInline(String versionName);

  /// Inline status shown when the current app version is already up to date
  ///
  /// In en, this message translates to:
  /// **'Current version {versionName} ({versionCode}) is up to date'**
  String updateAlreadyLatestInline(String versionName, int versionCode);

  /// Inline status shown when the update check fails on the settings page
  ///
  /// In en, this message translates to:
  /// **'Update check failed. Tap to retry.'**
  String get updateCheckFailedInline;

  /// Snackbar text for non-Android platforms
  ///
  /// In en, this message translates to:
  /// **'OTA update is only supported on Android'**
  String get otaAndroidOnly;

  /// Snackbar text while downloading OTA package
  ///
  /// In en, this message translates to:
  /// **'Downloading update package...'**
  String get updateDownloadingPackage;

  /// Update tile stage text while package is downloading
  ///
  /// In en, this message translates to:
  /// **'Downloading package'**
  String get updateStageDownloading;

  /// Update tile stage text while package is being verified
  ///
  /// In en, this message translates to:
  /// **'Verifying package'**
  String get updateStageVerifying;

  /// Update tile stage text while opening installer
  ///
  /// In en, this message translates to:
  /// **'Opening installer'**
  String get updateStageOpeningInstaller;

  /// Update tile progress detail line
  ///
  /// In en, this message translates to:
  /// **'{downloaded} / {total} ({percent}%)'**
  String updateProgressLine(String downloaded, String total, int percent);

  /// Update tile download speed line
  ///
  /// In en, this message translates to:
  /// **'Speed: {speed}'**
  String updateSpeedLine(String speed);

  /// Update tile remaining time line
  ///
  /// In en, this message translates to:
  /// **'ETA: {eta}'**
  String updateEtaLine(String eta);

  /// Dialog title shown before closing the app to install an update
  ///
  /// In en, this message translates to:
  /// **'Ready to install'**
  String get updateReadyToInstallTitle;

  /// Dialog body shown before closing the app to install an update
  ///
  /// In en, this message translates to:
  /// **'The app will close to apply the update and restart after installation finishes.'**
  String get updateReadyToInstallMessage;

  /// Confirmation action that closes the app and starts installation
  ///
  /// In en, this message translates to:
  /// **'Close and install'**
  String get updateRestartToInstallAction;

  /// Snackbar text after download completes
  ///
  /// In en, this message translates to:
  /// **'Download complete. Opening installer...'**
  String get updateOpeningInstaller;

  /// Snackbar text when installer returns done state
  ///
  /// In en, this message translates to:
  /// **'Installer flow finished.'**
  String get updateInstallerFinished;

  /// Snackbar text when install permission is denied
  ///
  /// In en, this message translates to:
  /// **'Install permission denied. Please allow unknown app installs.'**
  String get updateInstallPermissionDenied;

  /// Snackbar text for OTA download/install failures
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(String error);

  /// Title shown in the Windows updater window
  ///
  /// In en, this message translates to:
  /// **'MeloTrip Updater'**
  String get updateInstallerWindowTitle;

  /// Version line shown in the Windows updater window
  ///
  /// In en, this message translates to:
  /// **'Version {versionName} ({versionCode})'**
  String updateInstallerVersionLine(String versionName, int versionCode);

  /// Status text shown while the Windows updater window is starting
  ///
  /// In en, this message translates to:
  /// **'Preparing update...'**
  String get updateInstallerPreparing;

  /// Status text shown while waiting for the app to exit before update
  ///
  /// In en, this message translates to:
  /// **'Waiting for MeloTrip to close...'**
  String get updateInstallerWaitingForApp;

  /// Status text shown while extracting the Windows update archive
  ///
  /// In en, this message translates to:
  /// **'Extracting update package...'**
  String get updateInstallerExtractingArchive;

  /// Status text shown while copying updated files into place
  ///
  /// In en, this message translates to:
  /// **'Installing update...'**
  String get updateInstallerCopyingFiles;

  /// Status text shown while restarting the app after update
  ///
  /// In en, this message translates to:
  /// **'Restarting MeloTrip...'**
  String get updateInstallerRestartingApp;

  /// Heading shown in the Windows updater when installation fails
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateInstallerFailed;

  /// Error shown when the Windows updater receives invalid launch arguments
  ///
  /// In en, this message translates to:
  /// **'Updater arguments are invalid.'**
  String get updateInstallerInvalidArguments;

  /// Error shown when the Windows updater fails to initialize COM or required controls
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize Windows components for the updater.'**
  String get updateInstallerInitFailed;

  /// Error shown when the Windows updater cannot wait for the app process to exit
  ///
  /// In en, this message translates to:
  /// **'Failed to wait for MeloTrip to exit.'**
  String get updateInstallerWaitFailed;

  /// Error shown when the Windows updater cannot access a temporary directory
  ///
  /// In en, this message translates to:
  /// **'Failed to resolve a temporary directory.'**
  String get updateInstallerTempPathFailed;

  /// Error shown when the Windows updater cannot create its staging directory
  ///
  /// In en, this message translates to:
  /// **'Failed to create the staging directory.'**
  String get updateInstallerTempDirFailed;

  /// Error shown when the Windows updater cannot extract the downloaded archive
  ///
  /// In en, this message translates to:
  /// **'Failed to extract the update package.'**
  String get updateInstallerExtractFailed;

  /// Error shown when the Windows updater cannot copy updated files into place
  ///
  /// In en, this message translates to:
  /// **'Failed to install the update files.'**
  String get updateInstallerCopyFailed;

  /// Generic error message when an unknown error occurs
  ///
  /// In en, this message translates to:
  /// **'Unknown Error'**
  String get unknownError;

  /// Message when an unknown error is encountered during the process
  ///
  /// In en, this message translates to:
  /// **'Encounter Unknown Error'**
  String get encounterUnknownError;

  /// Desktop full player text when there is no active track
  ///
  /// In en, this message translates to:
  /// **'No song playing'**
  String get noSongPlaying;

  /// Audio channel label for stereo output
  ///
  /// In en, this message translates to:
  /// **'STEREO'**
  String get audioChannelStereo;

  /// Audio channel label for mono output
  ///
  /// In en, this message translates to:
  /// **'MONO'**
  String get audioChannelMono;

  /// Audio channel label for multi-channel output
  ///
  /// In en, this message translates to:
  /// **'{count}CH'**
  String audioChannelCount(int count);

  /// Audio sample rate string in kHz
  ///
  /// In en, this message translates to:
  /// **'{value} kHz'**
  String audioSampleRateKHz(String value);

  /// Audio bitrate string in kbps
  ///
  /// In en, this message translates to:
  /// **'{value} kbps'**
  String audioBitrateKbps(String value);

  /// Add to play queue next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get playAddToNext;

  /// Add to play queue last button
  ///
  /// In en, this message translates to:
  /// **'Last'**
  String get playAddToLast;

  /// Track label for toolbar
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get track;

  /// Edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Folder label
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// Id label
  ///
  /// In en, this message translates to:
  /// **'Id'**
  String get id;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Reset settings button label
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults'**
  String get resetToDefaults;

  /// Desktop settings general tab label
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsTabGeneral;

  /// Desktop settings appearance tab label
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTabAppearance;

  /// Desktop settings playback tab label
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get settingsTabPlayback;

  /// Desktop settings lyrics tab label
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get settingsTabLyrics;

  /// Desktop settings hotkeys tab label
  ///
  /// In en, this message translates to:
  /// **'Hotkeys'**
  String get settingsTabHotkeys;

  /// Desktop settings advanced tab label
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsTabAdvanced;

  /// Text alignment option start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get textAlignStart;

  /// Text alignment option center
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get textAlignCenter;

  /// Text alignment option end
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get textAlignEnd;

  /// Font weight option w300
  ///
  /// In en, this message translates to:
  /// **'w300'**
  String get fontWeightW300;

  /// Font weight option w400
  ///
  /// In en, this message translates to:
  /// **'w400'**
  String get fontWeightW400;

  /// Font weight option w500
  ///
  /// In en, this message translates to:
  /// **'w500'**
  String get fontWeightW500;

  /// Font weight option w600
  ///
  /// In en, this message translates to:
  /// **'w600'**
  String get fontWeightW600;

  /// Font weight option w700
  ///
  /// In en, this message translates to:
  /// **'w700'**
  String get fontWeightW700;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
