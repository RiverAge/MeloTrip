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
/// 速度用**滑动窗口平均**：取最近 [_window] 内的累计字节增量除以时长。
/// 纯全局平均（已下载÷全程）固然不抖，但真实吞吐中途大幅变化时它几乎不
/// 反映（冲高被全程摊平），用户看到的速度与"当前还差多久"脱节。窗口平均
/// 回答"最近这段下了多少"，真实吞吐变了，一个窗口周期后 UI 就跟上来。
///
/// 抖动来自三处，逐一压住：
///  1. dio 回调频率不均（burst 时 1ms 连发）→ [_minSpan] 门槛，跨度太短不算。
///  2. 窗口边界样本进出造成小幅回落（真实吞吐没变也抖）→ "方向不回退
///     ≤15% 沿用旧值"平滑。
///  3. 回调直通 UI → 2Hz 节流（见 compute），让速度数值不再每 0.3s 跳。
/// 窗口取 2s 是平滑度与跟手度的折中：短到能在真实减速后 2s 内反映出来，
/// 长到对单次回调抖动有平均效果。
class _DownloadProgressTracker {
  // (时刻, 累计已接收字节) 对。dio 给的 received 是从 0 起的单调累计值，
  // 用"窗口内最新 - 最早"做差即为窗口内净下载量，不受回调稀疏/密集影响。
  final List<({DateTime time, int bytes})> _samples = [];

  double _speedBytesPerSecond = 0;
  DateTime? _lastUiTickAt;

  // 窗口：取最近 2s 内的样本做平均。短到能在真实减速后 2s 内反映，长到对
  // 单次回调抖动有平均效果。
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

    // UI 刷新节流：稳定 ~2Hz（500ms 一拍），人眼感知为"在动"而非"在抖"。
    // 距上次刷新不足 500ms 一律压制，除非已跨越下一个整数百分点——后者
    // 保证进度条不会卡在整数位前让人感觉停滞。
    final int lastIntPercent = currentUiPercent.floor();
    final int newIntPercent = percent.floor();
    final bool crossedIntPercent = newIntPercent > lastIntPercent;
    final bool shouldThrottle =
        _lastUiTickAt != null &&
        now.difference(_lastUiTickAt!).inMilliseconds < 500 &&
        !crossedIntPercent;
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
    if (windowSpeed < 0) {
      _speedBytesPerSecond = 0;
      return;
    }
    // 方向不回退平滑：窗口边缘样本进出会让算出的速度小幅回落（真实吞吐没降，
    // 只是采样边界抖动）。新速度比上次下降不超过 15% 时沿用旧值，超过 15%
    // 才反映真实减速。这消除"速度数字忽大忽小"的最后一层抖动。
    final double last = _speedBytesPerSecond;
    if (last > 0 && windowSpeed < last && (last - windowSpeed) / last <= 0.15) {
      return;
    }
    _speedBytesPerSecond = windowSpeed;
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
