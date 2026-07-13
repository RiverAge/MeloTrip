part of '../app_update_service.dart';

/// [AppUpdateService] 的下载与校验内部实现。
///
/// 拆分到 extension 以保持 [AppUpdateService] 主文件在行数限制内。
/// 仅含私有方法，由主类的公开 API（[AppUpdateService.downloadAndVerifyPackage]
/// 等）调用，故不需要多态分发；对外 API 仍是主类实例方法，子类可正常重写。
/// 处于同一库（part of），可访问 `_dio`、`_buildDownloadFileName` 等私有成员。
extension AppUpdateServiceDownloadInternal on AppUpdateService {
  Future<File> _downloadAndVerifyPackage({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
    void Function(int mirrorIndex, int total)? onMirrorChanged,
  }) async {
    final dir = await getTemporaryDirectory();
    final filePath = p.join(dir.path, _buildDownloadFileName(update));
    final file = File(filePath);

    // 候选下载源：优先 mirrors，否则退化为 downloadUrl 单链。
    final urls = update.mirrors.isNotEmpty
        ? update.mirrors
        : <String>[update.downloadUrl];

    onStageChanged?.call(UpdateDownloadStage.downloading);

    final errors = <String>[];
    for (var i = 0; i < urls.length; i++) {
      final url = urls[i];
      onMirrorChanged?.call(i, urls.length);
      try {
        // 每个 mirror 都从干净状态开始全量下载。
        // 不做断点续传：公益 proxy 普遍不支持 Range，续传逻辑徒增复杂性
        // 且对 proxy 无效；GitHub 直链断了重下即可，代价可接受。
        if (await file.exists()) {
          await file.delete();
        }
        await _downloadFull(
          url: url,
          file: file,
          expectedSize: update.fileSize,
          onProgress: onProgress,
        );
        final verified = await _verifyDownloadedFile(file: file, update: update);
        if (verified) {
          onStageChanged?.call(UpdateDownloadStage.verifying);
          return file;
        }
        // 校验失败：当作该 mirror 失败，删文件切下一个。
        if (await file.exists()) {
          await file.delete();
        }
        errors.add('$url: checksum mismatch');
      } catch (e) {
        // 下载异常（连接失败/超时等）。
        if (await file.exists()) {
          await file.delete();
        }
        errors.add('$url: $e');
      }
    }

    throw StateError('All download mirrors failed:\n${errors.join('\n')}');
  }

  /// 校验已下载文件：非空、大小匹配（有声明时）、SHA-256 匹配（有声明时）。
  /// 任一不过返回 false（让外层切下一个 mirror）。
  Future<bool> _verifyDownloadedFile({
    required File file,
    required AppUpdateInfo update,
  }) async {
    final length = await file.length();
    if (length <= 0) return false;
    if (update.fileSize > 0 && length != update.fileSize) return false;

    final checksum = update.sha256.trim().toLowerCase();
    if (checksum.isEmpty) return true;

    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString().toLowerCase() == checksum;
  }

  /// 全量下载单个 mirror 到 [file]（FileMode.write 覆盖）。
  Future<void> _downloadFull({
    required String url,
    required File file,
    required int expectedSize,
    void Function(int received, int total, double progress)? onProgress,
  }) async {
    await _dio.download(
      url,
      file.path,
      options: Options(
        responseType: ResponseType.bytes,
        headers: const {'User-Agent': 'MeloTrip-App', 'Accept': '*/*'},
      ),
      onReceiveProgress: (received, total) {
        final effectiveTotal = total > 0 ? total : expectedSize;
        if (effectiveTotal <= 0) {
          onProgress?.call(received, 0, 0);
          return;
        }
        final progress = (received / effectiveTotal).clamp(0, 1).toDouble();
        onProgress?.call(received, effectiveTotal, progress);
      },
    );
  }

  /// 删除已下载的安装包（安装成功后 / 重新检查更新时清理）。
  /// 忽略不存在的文件。包文件命名固定，多次下载同名覆盖，故只删当前平台
  /// 对应的那一个文件即可，不会留下跨版本残留。
  Future<void> _deleteDownloadedPackage(AppUpdateInfo? update) async {
    File? target;
    try {
      final dir = await getTemporaryDirectory();
      final name = update != null
          ? _buildDownloadFileName(update)
          : 'melotrip${_defaultPackageExtension()}';
      target = File(p.join(dir.path, name));
      if (await target.exists()) {
        await target.delete();
      }
    } catch (_) {
      // 清理失败不应影响主流程。
    }
  }
}
