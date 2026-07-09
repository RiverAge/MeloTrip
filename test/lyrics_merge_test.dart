import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/lyrics/lyrics_merge.dart';

void main() {
  test('picks main kind with cueLine and moves it to front', () {
    final response = SubsonicResponse.fromJson(<String, dynamic>{
      'subsonic-response': <String, dynamic>{
        'status': 'ok',
        'lyricsList': <String, dynamic>{
          'structuredLyrics': <Map<String, dynamic>>[
            <String, dynamic>{
              'kind': 'translation',
              'lang': 'es',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'Hola'},
              ],
            },
            <String, dynamic>{
              'kind': 'main',
              'lang': 'ja',
              'synced': true,
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'こんにちは'},
              ],
              'agents': <Map<String, dynamic>>[
                <String, dynamic>{'id': 'v1', 'role': 'main'},
              ],
              'cueLine': <Map<String, dynamic>>[
                <String, dynamic>{
                  'index': 0,
                  'start': 0,
                  'end': 1000,
                  'value': 'こんにちは',
                  'agentId': 'v1',
                  'cue': <Map<String, dynamic>>[
                    <String, dynamic>{
                      'start': 0,
                      'end': 500,
                      'byteStart': 0,
                      'byteEnd': 2,
                      'value': 'こん',
                    },
                  ],
                },
              ],
            },
          ],
        },
      },
    });

    final merged = mergePreferredStructuredLyrics(response)
        .subsonicResponse
        ?.lyricsList
        ?.structuredLyrics;

    expect(merged, isNotNull);
    expect(merged, hasLength(2));
    // main 且有逐字者置首
    expect(merged!.first.kind, 'main');
    expect(merged.first.cueLine, isNotNull);
    expect(merged.first.cueLine!.first.cue!.first.value, 'こん');
    // 翻译条目保留在后
    expect(merged.last.kind, 'translation');
    expect(merged.last.lang, 'es');
  });

  test('falls back to main without cueLine when no enhanced data', () {
    final response = SubsonicResponse.fromJson(<String, dynamic>{
      'subsonic-response': <String, dynamic>{
        'status': 'ok',
        'lyricsList': <String, dynamic>{
          'structuredLyrics': <Map<String, dynamic>>[
            <String, dynamic>{
              // 无 enhanced：kind 缺失，视为 main
              'lang': 'en',
              'line': <Map<String, dynamic>>[
                <String, dynamic>{'start': 0, 'value': 'Hello'},
                <String, dynamic>{'start': 1000, 'value': 'World'},
              ],
            },
          ],
        },
      },
    });

    final merged = mergePreferredStructuredLyrics(response)
        .subsonicResponse
        ?.lyricsList
        ?.structuredLyrics;

    expect(merged, isNotNull);
    expect(merged, hasLength(1));
    expect(merged!.first.line, hasLength(2));
    expect(merged.first.line!.first.value, 'Hello');
    expect(merged.first.line!.last.value, 'World');
  });

  test('keeps original response when empty', () {
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
