import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
abstract class GenresEntity with _$GenresEntity {
  const factory GenresEntity({
    List<GenreEntity>? genre,
  }) = _GenresEntity;

  factory GenresEntity.fromJson(Map<String, dynamic> json) =>
      _$GenresEntityFromJson(json);
}

@freezed
abstract class GenreEntity with _$GenreEntity {
  const factory GenreEntity({
    @JsonKey(name: 'value') String? value,
    int? songCount,
    int? albumCount,
  }) = _GenreEntity;

  factory GenreEntity.fromJson(Map<String, dynamic> json) =>
      _$GenreEntityFromJson(json);
}
