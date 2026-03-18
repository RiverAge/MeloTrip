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

  _DownloadProgressSnapshot? compute({
    required int received,
    required int total,
    required double progress,
    required double currentUiPercent,
  }) {
    final double percent = (progress * 100).clamp(0, 100).toDouble();
    final DateTime now = DateTime.now();
    _updateSpeed(now: now, received: received);

    final bool shouldThrottle =
        _lastUiTickAt != null &&
        now.difference(_lastUiTickAt!).inMilliseconds < 300 &&
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
      if (deltaMs > 0 && deltaBytes >= 0) {
        final double instantSpeed = deltaBytes / (deltaMs / 1000);
        _speedBytesPerSecond = _speedBytesPerSecond <= 0
            ? instantSpeed
            : _speedBytesPerSecond * 0.75 + instantSpeed * 0.25;
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
