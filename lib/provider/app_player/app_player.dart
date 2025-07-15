import 'package:audio_service/audio_service.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_player.g.dart';

@Riverpod(keepAlive: true)
class AppPlayerHandler extends _$AppPlayerHandler {
  @override
  Future<AppPlayer?> build() async {
    // 你可以加一个打印语句来验证这个方法真的只会被调用一次
    print("--- Initializing AudioService and creating AppPlayer instance ---");

    final audioHandler = await AudioService.init(
      builder: () => AppPlayer(), // AppPlayer 是你的 AudioHandler 实现
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.meme.melotrip.audio',
        androidNotificationChannelName: 'Audio Service MeloTrip',
        androidNotificationOngoing: true,
      ),
    );

    // (可选但推荐) 管理服务的关闭
    // onDispose 会在 Provider 被销毁时调用
    // 因为设置了 keepAlive: true, 这只会在整个 ProviderScope (即你的App)
    // 被销毁时才会发生，这是执行清理工作的完美时机。
    ref.onDispose(() {
      print("--- Shutting down AudioService ---");
      audioHandler.stop(); // 或者其他你需要的清理逻辑
      // audio_service 0.18+ 会自动处理 shutdown, 但显式调用 stop() 是个好习惯
    });

    return audioHandler;
  }
}
