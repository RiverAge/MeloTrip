// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get name => 'Name';

  @override
  String get comment => 'Comment';

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
  String manyArtists(num artistCount) {
    return '... and \$$artistCount artists';
  }

  @override
  String get noTitle => 'No Title';

  @override
  String get endOfData => 'End Of Data';

  @override
  String get noDataFound => 'No Data Found';

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
  String get recommendedToday => 'Recommended Today';

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
  String get themeSystemDefault => 'System Default';

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
  String get playQueue => 'Play Queue';

  @override
  String get playNext => 'Play Next';

  @override
  String get addToPlayQueue => 'Add Queue';

  @override
  String get removeFromPlayQueue => 'Remove Queue';

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
  String get noLyricsFound => 'No Lyrics Found';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get encounterUnknownError => 'Encounter Unknown Error';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn(): super('zh_CN');

  @override
  String get settings => '设置';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get name => '名称';

  @override
  String get comment => '备注';

  @override
  String get loginInputHostHint => '请输入服务器地址';

  @override
  String get loginInputUserHint => '请输入用户名';

  @override
  String get loginInputPasswordHint => '请输入密码';

  @override
  String get login => '登录';

  @override
  String get logout => '退出登录';

  @override
  String get logoutDialogConfirm => '确认退出登录？';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get version => '版本';

  @override
  String get artist => '艺术家';

  @override
  String get album => '专辑';

  @override
  String get song => '歌曲';

  @override
  String get songCountUnit => '首';

  @override
  String get albumCount => '专辑数';

  @override
  String manyArtists(num artistCount) {
    return '...等\$$artistCount位艺术家';
  }

  @override
  String get noTitle => '无标题';

  @override
  String get endOfData => '到底了';

  @override
  String get noDataFound => '暂无数据';

  @override
  String get serverOnline => '在线';

  @override
  String get serverOffline => '离线';

  @override
  String get serverStatus => '状态';

  @override
  String get serverScaning => '正在扫描';

  @override
  String get serverLastScanTime => '上次扫描';

  @override
  String get serverSongCount => '歌曲数量';

  @override
  String get cachedSize => '已缓存';

  @override
  String get calculating => '计算中...';

  @override
  String get recentAdded => '近期添加';

  @override
  String get randomAlbum => '随机专辑';

  @override
  String get viewAll => '查看全部';

  @override
  String get rencentPlayed => '近期播放';

  @override
  String get recommendedToday => '今日推荐';

  @override
  String get searchHint => '搜索歌曲、艺术家或专辑...';

  @override
  String get searchHistory => '搜索历史';

  @override
  String get theme => '主题';

  @override
  String get themeDark => '深色';

  @override
  String get themeLight => '浅色';

  @override
  String get themeSystemDefault => '跟随系统';

  @override
  String get songMetaDuration => '时长';

  @override
  String get songMetaFormat => '格式';

  @override
  String get songMetaBitRate => '比特率';

  @override
  String get songMetaGenre => '流派';

  @override
  String get songMetaYear => '年份';

  @override
  String get songMetaPath => '路径';

  @override
  String get songMetaSampling => '采样率';

  @override
  String get songMetaTrackNumber => '音轨号';

  @override
  String get songMetaDiskNumber => '盘号';

  @override
  String get songMetaSize => '大小';

  @override
  String get favorite => '收藏';

  @override
  String get unfavorite => '取消收藏';

  @override
  String get myFavorites => '我的收藏';

  @override
  String get playQueue => '播放队列';

  @override
  String get playNext => '下一首播放';

  @override
  String get addToPlayQueue => '加到播放队列';

  @override
  String get removeFromPlayQueue => '移出播放队列';

  @override
  String get playlist => '歌单';

  @override
  String get myPlaylist => '我的歌单';

  @override
  String get addToPlaylist => '加至歌单';

  @override
  String get createNewPlaylist => '新建歌单';

  @override
  String get playlistInputNameHint => '输入歌单名称';

  @override
  String get playlistInputCommentHint => '输入备注';

  @override
  String get playlistIsPublic => '是否公开';

  @override
  String playlistDeleteConfirmation(String name) {
    return '确定要删除歌单 $name ?';
  }

  @override
  String songHasAddedToPlaylistToast(String playlistName) {
    return '已添加到 $playlistName.';
  }

  @override
  String get playModeNone => '顺序播放';

  @override
  String get playModeLoop => '列表循环';

  @override
  String get playModeSingle => '单曲循环';

  @override
  String get shuffleOn => '随机播放开启';

  @override
  String get shuffleOff => '随机播放关闭';

  @override
  String get musicQuality => '音质';

  @override
  String get musicQualitySmooth => '流畅';

  @override
  String get musicQualityMedium => '均衡';

  @override
  String get musicQualityHigh => '高清';

  @override
  String get musicQualityVeryHigh => '超清';

  @override
  String get musicQualityLossless => '无损';

  @override
  String get noLyricsFound => '无歌词';

  @override
  String get unknownError => '未知错误';

  @override
  String get encounterUnknownError => '遇到未知错误';
}
