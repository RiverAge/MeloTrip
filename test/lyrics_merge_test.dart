import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/lyrics/lyrics_merge.dart';

void main() {
  test('mergePreferredStructuredLyrics picks best source and skips latn', () {
    final response = SubsonicResponse.fromJson(<String, dynamic>{
      'subsonic-response': <String, dynamic>{
        'status': 'ok',
        'lyricsList': <String, dynamic>{
          'structuredLyrics': <Map<String, dynamic>>[
            <String, dynamic>{
              'lang': 'ori-NetEase',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'Hello'},
                <String, dynamic>{'start': 1000, 'value': 'World'},
              ],
            },
            <String, dynamic>{
              'lang': 'zho-NetEase',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'CN-1'},
                <String, dynamic>{'start': 1000, 'value': 'CN-2'},
              ],
            },
            <String, dynamic>{
              'lang': 'latn-NetEase',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'Ni Hao'},
              ],
            },
            <String, dynamic>{
              'lang': 'ori-Other',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'Other Source'},
              ],
            },
          ],
        },
      },
    });

    final merged = mergePreferredStructuredLyrics(
      response,
    ).subsonicResponse?.lyricsList?.structuredLyrics;

    expect(merged, isNotNull);
    expect(merged, hasLength(1));
    expect(merged!.first.lang, 'NetEase');
    expect(merged.first.line, hasLength(2));
    expect(merged.first.line!.first.value, <String>['Hello', 'CN-1']);
    expect(merged.first.line!.last.value, <String>['World', 'CN-2']);
  });

  test('mergePreferredStructuredLyrics keeps original response when empty', () {
    final response = SubsonicResponse.fromJson(<String, dynamic>{
      'subsonic-response': <String, dynamic>{
        'status': 'ok',
        'lyricsList': <String, dynamic>{'structuredLyrics': <Object>[]},
      },
    });

    final merged = mergePreferredStructuredLyrics(response);

    expect(identical(merged, response), isTrue);
  });
}
