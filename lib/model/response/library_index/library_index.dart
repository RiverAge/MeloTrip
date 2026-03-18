import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/artist/artist.dart';

part 'library_index.freezed.dart';
part 'library_index.g.dart';

@freezed
abstract class ArtistsEntity with _$ArtistsEntity {
  const factory ArtistsEntity({List<ArtistIndexBucketEntity>? index}) =
      _ArtistsEntity;

  factory ArtistsEntity.fromJson(Map<String, dynamic> json) =>
      _$ArtistsEntityFromJson(json);
}

@freezed
abstract class ArtistIndexBucketEntity with _$ArtistIndexBucketEntity {
  const factory ArtistIndexBucketEntity({
    String? name,
    List<ArtistEntity>? artist,
  }) = _ArtistIndexBucketEntity;

  factory ArtistIndexBucketEntity.fromJson(Map<String, dynamic> json) =>
      _$ArtistIndexBucketEntityFromJson(json);
}

@freezed
abstract class IndexesEntity with _$IndexesEntity {
  const factory IndexesEntity({
    String? lastModified,
    List<ArtistIndexBucketEntity>? index,
  }) = _IndexesEntity;

  factory IndexesEntity.fromJson(Map<String, dynamic> json) =>
      _$IndexesEntityFromJson(json);
}

@freezed
abstract class DirectoryEntity with _$DirectoryEntity {
  const factory DirectoryEntity({
    String? id,
    String? parent,
    String? name,
    String? title,
    List<DirectoryChildEntity>? child,
  }) = _DirectoryEntity;

  factory DirectoryEntity.fromJson(Map<String, dynamic> json) =>
      _$DirectoryEntityFromJson(json);
}

@freezed
abstract class DirectoryChildEntity with _$DirectoryChildEntity {
  const factory DirectoryChildEntity({
    String? id,
    String? parent,
    bool? isDir,
    String? title,
    String? name,
    String? album,
    String? genre,
    int? year,
    int? duration,
    String? coverArt,
    String? artist,
  }) = _DirectoryChildEntity;

  factory DirectoryChildEntity.fromJson(Map<String, dynamic> json) =>
      _$DirectoryChildEntityFromJson(json);
}
