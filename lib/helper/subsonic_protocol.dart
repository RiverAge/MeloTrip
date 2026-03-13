const subsonicApiVersion = '1.16.1';
const subsonicClientName = 'melo_trip';

const subsonicStreamPath = '/rest/stream';
const subsonicCoverArtPath = '/rest/getCoverArt';

const Set<String> subsonicCacheableMediaPaths = <String>{
  subsonicStreamPath,
  subsonicCoverArtPath,
};

const Set<String> subsonicRequiredMediaQueryParameterNames = <String>{
  'u',
  't',
  's',
  'v',
  'c',
  'id',
};

const Set<String> subsonicDigestExcludedQueryParameterNames = <String>{
  'u',
  't',
  's',
  'c',
  'v',
  '_',
};

bool isCacheableSubsonicMediaUri(Uri uri) {
  if (!subsonicCacheableMediaPaths.contains(uri.path)) {
    return false;
  }

  final queryParameters = uri.queryParameters;
  return subsonicRequiredMediaQueryParameterNames.every(
    queryParameters.containsKey,
  );
}

String buildCacheableSubsonicMediaDigest(Uri uri) {
  return uri
      .replace(
        queryParameters: Map<String, String>.from(uri.queryParameters)
          ..removeWhere(
            (key, _) => subsonicDigestExcludedQueryParameterNames.contains(key),
          ),
      )
      .toString();
}
