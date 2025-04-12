part of 'index.dart';

String fileSizeFormatter(int? sizeInB) {
  if (sizeInB == null) {
    return '';
  }
  if (sizeInB < 1024) {
    return '${sizeInB.toString()} B';
  }
  if (sizeInB < 1024 * 1024) {
    return '${((sizeInB / 1024) * 100).round() / 100} KB';
  }
  if (sizeInB < 1024 * 1024 * 1024) {
    return '${((sizeInB / 1024 / 1024) * 100).round() / 100} MB';
  }
  if (sizeInB < 1024 * 1024 * 1024 * 1024) {
    return '${((sizeInB / 1024 / 1024 / 1024) * 100).round() / 100} GB';
  }
  return '${((sizeInB / 1024 / 1024 / 1024 / 1024) * 100).round() / 100} TB';
}
