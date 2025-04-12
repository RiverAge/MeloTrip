part of 'index.dart';

String durationFormatter(int? seconds) {
  if (seconds == null) {
    return '';
  }
  if (seconds < 3600) {
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  } else {
    return Duration(seconds: seconds)
        .toString()
        .split('.')
        .first
        .padLeft(8, '0');
  }
}
