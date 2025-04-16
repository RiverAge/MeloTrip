import 'dart:async';
import 'dart:convert';

import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth/auth.dart';
import 'package:melo_trip/model/rec_today/rec_today.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  static Completer<User>? _completer;

  Auth? _auth;

  Auth? get auth {
    return _auth;
  }

  RecTodayEntity? _recToday;

  RecTodayEntity? get recToday {
    return _recToday;
  }

  set recToday(RecTodayEntity? recToday) {
    _recToday = recToday;
    _prefs?.setString('__u__', jsonEncode(toJson()));
  }

  List<String>? _searchHistory;
  List<String>? get searchHistory {
    return _searchHistory;
  }

  set searchHistory(List<String>? searchHistory) {
    _searchHistory = searchHistory;
    _prefs?.setString('__u__', jsonEncode(toJson()));
  }

  String? _maxRate;
  String? get maxRate {
    return _maxRate;
  }

  set maxRate(String? maxRate) {
    _maxRate = maxRate;
    _prefs?.setString('__u__', jsonEncode(toJson()));
  }

  PlaylistMode _playlistMode = PlaylistMode.loop;
  PlaylistMode get playlistMode {
    return _playlistMode;
  }

  set playlistMode(PlaylistMode playlistMode) {
    _playlistMode = playlistMode;
    _prefs?.setString('__u__', jsonEncode(toJson()));
  }

  Map<String, dynamic> toJson() => {
    'auth': _auth?.toJson(),
    'recToday': _recToday?.toJson(),
    'searchHistory': _searchHistory,
    'maxRate': _maxRate,
    'playlistMode': _playlistMode.toJson(),
  };

  SharedPreferences? _prefs;

  User._();

  update(Auth auth) {
    _auth = auth;
    _prefs?.setString('__u__', jsonEncode(toJson()));
  }

  clear() {
    _prefs?.remove('__u__');
    _auth = null;
    _recToday = null;
  }

  static Future<User> get instance async {
    if (_completer == null) {
      final completer = Completer<User>();
      _completer = completer;
      final instance = User._();
      instance._prefs = await SharedPreferences.getInstance();
      final u = instance._prefs?.getString('__u__');
      if (u != null) {
        Map<String, dynamic> ret = jsonDecode(u);
        if (ret['auth'] != null) {
          final auth = Auth.fromJson(ret['auth']);
          instance._auth = auth;
        }
        if (ret['recToday'] != null) {
          final recToday = RecTodayEntity.fromJson(ret['recToday']);
          instance._recToday = recToday;
        }
        if (ret['searchHistory'] != null) {
          final List<dynamic> searchHistory = ret['searchHistory'] ?? [];
          instance._searchHistory =
              searchHistory.map((e) => e as String).toList();
        }
        if (ret['playlistMode'] != null) {
          final playlistMode = ret['playlistMode'] as String;
          instance._playlistMode = PlaylistModeExtension.fromJson(playlistMode);
        }

        final maxRate = ret['maxRate'] ?? '32';
        instance._maxRate = maxRate;
      } else {
        instance._maxRate = '32';
      }

      completer.complete(instance);
    }
    return _completer!.future;
  }
}

extension PlaylistModeExtension on PlaylistMode {
  /// Convert the enum to a string for JSON serialization
  String toJson() {
    switch (this) {
      case PlaylistMode.none:
        return 'none';
      case PlaylistMode.single:
        return 'single';
      case PlaylistMode.loop:
        return 'loop';
    }
  }

  /// Convert a string from JSON back to an enum
  static PlaylistMode fromJson(String json) {
    switch (json) {
      case 'none':
        return PlaylistMode.none;
      case 'single':
        return PlaylistMode.single;
      case 'loop':
        return PlaylistMode.loop;
      default:
        return PlaylistMode.loop;
    }
  }
}
