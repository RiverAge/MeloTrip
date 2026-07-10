import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  test('SongEntity parses and serializes rich payload', () {
    final song = SongEntity.fromJson({
      'id': 's1',
      'parent': 'p1',
      'isDir': false,
      'title': 'Title',
      'album': 'Album',
      'artist': 'Artist',
      'track': 1,
      'year': 2026,
      'coverArt': 'c1',
      'size': 12345,
      'contentType': 'audio/flac',
      'suffix': 'flac',
      'starred': '2026-03-01T00:00:00.000Z',
      'duration': 240,
      'bitRate': 320,
      'path': '/music/1.flac',
      'discNumber': 1,
      'created': '2026-03-01T00:00:00.000Z',
      'albumId': 'a1',
      'artistId': 'ar1',
      'type': 'music',
      'userRating': 5,
      'isVideo': false,
      'bpm': 120,
      'comment': 'memo',
      'sortName': 'Title',
      'mediaType': 'audio',
      'musicBrainzId': 'mb-1',
      'genres': [
        {'name': 'Rock'},
      ],
      'replayGain': {'trackPeak': 1, 'albumPeak': 2},
      'channelCount': 2,
      'genre': 'Rock',
      'samplingRate': 44100,
      'bitDepth': 16,
      'moods': ['Happy'],
      'artists': [
        {'id': 'ar1', 'name': 'Artist'},
      ],
      'displayArtist': 'Artist',
      'albumArtists': [
        {'id': 'aar1', 'name': 'Album Artist'},
      ],
      'displayAlbumArtist': 'Album Artist',
      'contributors': [
        {
          'role': 'composer',
          'artist': {'id': 'c1', 'name': 'Composer'},
        },
        {
          'role': 'performer',
          'subRole': 'Guitar',
          'artist': {'id': 'p1', 'name': 'Performer'},
        },
      ],
      'displayComposer': 'Composer',
      'explicitStatus': 'clean',
    });

    expect(song.id, 's1');
    expect(song.title, 'Title');
    expect(song.genres?.single.name, 'Rock');
    expect(song.replayGain?.trackPeak, 1);
    expect(song.artists?.single.id, 'ar1');
    expect(song.albumArtists?.single.id, 'aar1');
    expect(song.contributors?.length, 2);
    final composer = song.contributors?[0];
    expect(composer?.role, 'composer');
    expect(composer?.id, 'c1');
    expect(composer?.name, 'Composer');
    expect(composer?.subRole, isNull);
    final performer = song.contributors?[1];
    expect(performer?.role, 'performer');
    expect(performer?.subRole, 'Guitar');
    expect(performer?.id, 'p1');
    expect(performer?.name, 'Performer');
    expect(song.explicitStatus, 'clean');

    final json = song.toJson();
    expect(json['id'], 's1');
    expect(json['genres'], isA<List<dynamic>>());
    expect(json['artists'], isA<List<dynamic>>());
    expect(json['contributors'], isA<List<dynamic>>());
    final composerOut =
        (json['contributors'] as List<dynamic>).first as Map<String, dynamic>;
    expect(composerOut['role'], 'composer');
    expect(composerOut['artist'], isA<Map<String, dynamic>>());
    expect((composerOut['artist'] as Map<String, dynamic>)['id'], 'c1');
  });
}
