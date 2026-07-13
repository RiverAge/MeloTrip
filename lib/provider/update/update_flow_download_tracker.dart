part of 'update_flow.dart';

class _DownloadProgressSnapshot {
  const _DownloadProgressSnapshot({
    required this.percent,
    required this.receivedBytes,
    required this.totalBytes,
    required this.speedBytesPerSecond,
    required this.etaSeconds,
  });

  final double percent;
  final int receivedBytes;
  final int totalBytes;
  final double speedBytesPerSecond;
  final int? etaSeconds;
}

/// 下载速度采样。
///
/// 用滑动窗口平均速度，而非指数加权（EWMA）。理由：
/// EWMA 对历史值衰减太慢（0.85/0.15 时一拍只掉 15%），下载初期一旦冲高，
/// 真实速度随后掉下来，UI 也会长期"黏"在偏高的旧值上。窗口平均直接回答
/// "最近 N 秒下了多少字节"，真实吞吐变了，N 秒后 UI 就反映出来，且对
/// 单次回调抖动天然平滑。窗口取 2s 是平滑度与跟手度的折中。
class _DownloadProgressTracker {
  // (时刻, 累计已接收字节) 对。dio 给的 received 是从 0 起的单调累计值，
  // 用"窗口内最新 - 最早"做差即为窗口内净下载量，不受回调稀疏/密集影响。
  final List<({DateTime time, int bytes})> _samples = [];

  double _speedBytesPerSecond = 0;
  DateTime? _lastUiTickAt;

  // 窗口：取最近 2s 内的样本做平均。
  static const Duration _window = Duration(seconds: 2);
  // 最小时间跨度：样本间隔太短时算出的瞬时速度会尖刺（burst 时 dio 可能
  // 1ms 内连发多次回调）。低于此跨度则沿用上次速度，不算新值。
  static const Duration _minSpan = Duration(milliseconds: 200);

  _DownloadProgressSnapshot? compute({
    required int received,
    required int total,
    required double progress,
    required double currentUiPercent,
  }) {
    final double percent = (progress * 100).clamp(0, 100).toDouble();
    final DateTime now = DateTime.now();
    _updateSpeed(now: now, received: received);

    // UI 刷新节流：500ms 一次（约 2Hz），人眼感知为"在动"而非"在抖"。
    // 仅当百分比几乎没变化时才压制；进度真在走就让它通过，避免进度条卡顿。
    final bool shouldThrottle =
        _lastUiTickAt != null &&
        now.difference(_lastUiTickAt!).inMilliseconds < 500 &&
        (percent - currentUiPercent).abs() < 0.2;
    if (shouldThrottle) {
      return null;
    }

    _lastUiTickAt = now;
    return _DownloadProgressSnapshot(
      percent: percent,
      receivedBytes: received,
      totalBytes: total,
      speedBytesPerSecond: _speedBytesPerSecond,
      etaSeconds: _estimateEtaSeconds(received: received, total: total),
    );
  }

  void _updateSpeed({required DateTime now, required int received}) {
    // 跳过非单调样本：dio 理论上单调递增，但出现 0 / 回退时不要让它污染窗口。
    if (_samples.isNotEmpty && received < _samples.last.bytes) {
      return;
    }

    _samples.add((time: now, bytes: received));
    _evict(now);

    // 需要至少 2 个样本才能算斜率。
    if (_samples.length < 2) {
      return;
    }

    final newest = _samples.last;
    final oldest = _samples.first;
    final int deltaMs = newest.time.difference(oldest.time).inMilliseconds;
    if (deltaMs < _minSpan.inMilliseconds) {
      // 采样跨度太短：瞬时速度会尖刺，沿用上次记录值。
      return;
    }
    final int deltaBytes = newest.bytes - oldest.bytes;
    final double windowSpeed = deltaBytes / (deltaMs / 1000);
    _speedBytesPerSecond = windowSpeed < 0 ? 0 : windowSpeed;
  }

  /// 丢弃早于 now - 窗口 的样本，保留窗口内的。
  void _evict(DateTime now) {
    final DateTime cutoff = now.subtract(_window);
    int i = 0;
    while (i < _samples.length && _samples[i].time.isBefore(cutoff)) {
      i++;
    }
    // 至少保留窗口边缘那一个样本作为锚点，使差分有意义。
    if (i > 1) {
      _samples.removeRange(0, i - 1);
    }
  }

  int? _estimateEtaSeconds({required int received, int total = 0}) {
    if (_speedBytesPerSecond <= 0 || total <= 0) {
      return null;
    }
    final int rawEta =
        ((total - received).clamp(0, total) / _speedBytesPerSecond).ceil();
    return ((rawEta / 5).round() * 5);
  }
}
