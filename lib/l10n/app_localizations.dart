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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'CN')
  ];

  /// Tabbar Settings text
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

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

  /// Text for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

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

  /// Plural form for many artists
  ///
  /// In en, this message translates to:
  /// **'... and \${artistCount} artists'**
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
  /// **'No Data Found'**
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

  /// Title of recommended songs for today
  ///
  /// In en, this message translates to:
  /// **'Recommended Today'**
  String get recommendedToday;

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

  /// System default theme option for app
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystemDefault;

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

  /// Remove from user play queue
  ///
  /// In en, this message translates to:
  /// **'Remove Queue'**
  String get removeFromPlayQueue;

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

  /// Lyrics of Song could not be found
  ///
  /// In en, this message translates to:
  /// **'No Lyrics Found'**
  String get noLyricsFound;

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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
