import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';

String resolveAppFailureMessage(
  AppLocalizations l10n, {
  AppFailureType? type,
  AppFailure? failure,
}) {
  final resolvedType = failure?.type ?? type;
  return switch (resolvedType) {
    AppFailureType.network => l10n.globalErrorNetwork,
    AppFailureType.unauthorized => l10n.globalErrorUnauthorized,
    AppFailureType.server => l10n.globalErrorServer,
    AppFailureType.protocol => l10n.globalErrorProtocol,
    AppFailureType.unknown || null => l10n.unknownError,
  };
}
