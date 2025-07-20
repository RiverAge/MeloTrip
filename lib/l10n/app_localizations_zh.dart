// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '设置';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get revoke => '撤销';

  @override
  String get delete => '删除';

  @override
  String get deleted => '已删除';

  @override
  String get save => '保存';

  @override
  String get name => '名称';

  @override
  String get comment => '备注';

  @override
  String get language => '语言';

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
  String get systemDefault => '跟随系统';

  @override
  String manyArtists(num artistCount) {
    return '...等$artistCount位艺术家';
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
  String get guessYouLike => '猜你喜欢';

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
  String get playQueueCleared => '播放队列已清空';

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
  String get english => '英语';

  @override
  String get simpleChinese => '简体中文';

  @override
  String get us => '美国';

  @override
  String get cn => '中国';

  @override
  String get noLyricsFound => '无歌词';

  @override
  String get unknownError => '未知错误';

  @override
  String get encounterUnknownError => '遇到未知错误';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String get settings => '设置';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get revoke => '撤销';

  @override
  String get delete => '删除';

  @override
  String get deleted => '已删除';

  @override
  String get save => '保存';

  @override
  String get name => '名称';

  @override
  String get comment => '备注';

  @override
  String get language => '语言';

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
  String get systemDefault => '跟随系统';

  @override
  String manyArtists(num artistCount) {
    return '...等$artistCount位艺术家';
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
  String get guessYouLike => '猜你喜欢';

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
  String get playQueueCleared => '播放队列已清空';

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
  String get english => '英语';

  @override
  String get simpleChinese => '简体中文';

  @override
  String get us => '美国';

  @override
  String get cn => '中国';

  @override
  String get noLyricsFound => '无歌词';

  @override
  String get unknownError => '未知错误';

  @override
  String get encounterUnknownError => '遇到未知错误';
}
