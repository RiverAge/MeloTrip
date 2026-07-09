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

class _DownloadProgressTracker {
  int _lastReceivedBytes = 0;
  DateTime? _lastTickAt;
  DateTime? _lastUiTickAt;
  double _speedBytesPerSecond = 0;
  // 速度归零缓冲：网络一卡会让瞬时速度掉到 0，UI 上 "/s" 段随之闪烁。
  // 只有连续 _stallTicks 次采样都拿不到正向 delta 才认定为真正停滞。
  int _stallTicks = 0;
  static const int _stallTicksLimit = 3;

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
    if (_lastTickAt != null) {
      final int deltaMs = now.difference(_lastTickAt!).inMilliseconds;
      final int deltaBytes = received - _lastReceivedBytes;
      if (deltaMs > 0 && deltaBytes > 0) {
        final double instantSpeed = deltaBytes / (deltaMs / 1000);
        // 低通滤波：0.85/0.15，比 0.75/0.25 更抗尖刺，UI 数字不会忽大忽小。
        _speedBytesPerSecond = _speedBytesPerSecond <= 0
            ? instantSpeed
            : _speedBytesPerSecond * 0.85 + instantSpeed * 0.15;
        _stallTicks = 0;
      } else if (deltaBytes <= 0) {
        // 本采样窗口无增量。先衰减已记录速度而非立刻归零，连续多帧无增量才清零，
        // 避免 "/s" 段在速度正常波动时反复出现/消失。
        _stallTicks++;
        if (_stallTicks >= _stallTicksLimit) {
          _speedBytesPerSecond = 0;
        } else {
          _speedBytesPerSecond *= 0.5;
        }
      }
    }
    _lastTickAt = now;
    _lastReceivedBytes = received;
  }

  int? _estimateEtaSeconds({required int received, required int total}) {
    if (_speedBytesPerSecond <= 0 || total <= 0) {
      return null;
    }
    final int rawEta =
        ((total - received).clamp(0, total) / _speedBytesPerSecond).ceil();
    return ((rawEta / 5).round() * 5);
  }
}
