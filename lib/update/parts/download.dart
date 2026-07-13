part of '../app_update_service.dart';

/// 服务器不支持续传时抛出（200 全量响应 / 416 / 等），触发退化为全量下载。
class _RangeNotResumable implements Exception {
  const _RangeNotResumable();
}

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
        // 仅在切换到后续 mirror 时清掉前一个 mirror 的半成品。
        // 首个 mirror 保留本地半成品，以便复用 Range 续传（同一 URL 的断点）；
        // 后续 mirror 跨源，断点不通用且 proxy 多不支持 Range，从干净开始。
        if (i > 0 && await file.exists()) {
          await file.delete();
        }
        await _downloadWithResume(
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
        // 下载异常（连接失败/超时/Range 不可续等）。
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

  /// 带 HTTP Range 断点续传的下载。
  ///
  /// 若本地已存在半成品文件，以 `Range: bytes=<已下字节>-` 请求续传：
  ///   - 206 Partial Content：服务器支持续传，从断点 append 接着写。
  ///   - 200 OK：服务器忽略 Range 或不支持，从头覆盖写（退化为普通下载）。
  ///   - 416 Range Not Satisfiable：本地文件比远端还大（损坏/版本错位），
  ///     删掉重来。
  /// 进度回调的 received 已加上断点偏移，反映真实已下载量。
  /// 无 `update.fileSize`（=0）时不尝试续传，直接全量下载。
  Future<void> _downloadWithResume({
    required String url,
    required File file,
    required int expectedSize,
    void Function(int received, int total, double progress)? onProgress,
  }) async {
    final int existing = (await file.exists()) ? await file.length() : 0;
    // 仅当有预期大小、且本地已有部分但未完成时才尝试续传。
    final bool canResume =
        expectedSize > 0 && existing > 0 && existing < expectedSize;

    if (canResume) {
      try {
        await _fetchRangeAndAppend(
          url: url,
          file: file,
          resumeFrom: existing,
          expectedSize: expectedSize,
          onProgress: onProgress,
        );
        return;
      } on _RangeNotResumable {
        // 服务器拒绝续传（200 全量 / 416 / 其它非 206）。
        // 删掉旧半成品，走全量下载。
        if (await file.exists()) {
          await file.delete();
        }
      } on DioException catch (e) {
        // 网络抖动等：保留半成品以便下次重试，向上抛出让调用方决定重试。
        throw StateError(
          'Resume download failed: ${_summarizeDioException(e)}',
        );
      }
    } else if (existing > 0) {
      // 本地已有完整或超出预期的残留：覆盖。
      await file.delete();
    }

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

  Future<void> _fetchRangeAndAppend({
    required String url,
    required File file,
    required int resumeFrom,
    required int expectedSize,
    void Function(int received, int total, double progress)? onProgress,
  }) async {
    final response = await _dio.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: <String, String>{
          'User-Agent': 'MeloTrip-App',
          'Accept': '*/*',
          'Range': 'bytes=$resumeFrom-',
        },
      ),
    );

    final int status = response.statusCode ?? 0;
    if (status != 206) {
      // 200 = 服务器忽略 Range 给了全量；416 = 范围不满足；
      // 其它非 2xx 由 dio 自动抛错。任一情况都不能续传。
      throw const _RangeNotResumable();
    }

    // 续传：以 append 模式接在已有字节之后。
    final sink = file.openWrite(mode: FileMode.append);
    try {
      final stream = response.data!.stream;
      int received = resumeFrom;
      await for (final chunk in stream) {
        sink.add(chunk);
        received += chunk.length;
        final progress = expectedSize > 0
            ? (received / expectedSize).clamp(0, 1).toDouble()
            : 0.0;
        onProgress?.call(received, expectedSize, progress);
      }
      await sink.flush();
    } finally {
      await sink.close();
    }
  }

  String _summarizeDioException(DioException e) {
    final code = e.response?.statusCode;
    return 'DioException(statusCode=$code, message=${e.message})';
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
