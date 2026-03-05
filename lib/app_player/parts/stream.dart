part of '../player.dart';

extension PlayerStream on AppPlayer {
  Stream<Duration> get positionStream => _positionSubject.stream;
  Stream<Duration?> get durationStream => _durationSubject.stream;
  Stream<Duration> get bufferedPositionStream =>
      _bufferedPositionSubject.stream;
  Stream<bool> get playingStream => _playingSubject.stream;
  Stream<PlaylistMode> get playlistModeStream => _playlistModeSubject.stream;
  Stream<PlayQueue> get playQueueStream => _playQueueSubject.stream;
  Stream<double> get volumeStream => _volumeSubject.stream;
  Stream<bool> get shuffleStream => _shuffleSubject.stream;
  Stream<String> get errorStream => _errorSubject.stream;
}
