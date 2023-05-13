// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: json['id'] as int,
      original_title: json['original_title'] as String,
      backdrop_path: json['backdrop_path'] as String?,
      poster_path: json['poster_path'] as String?,
      homepage: json['homepage'] as String?,
      overview: json['overview'] as String,
      release_date: json['release_date'] as String?,
      vote_average: (json['vote_average'] as num).toDouble(),
    );

// ignore: unused_element
Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'original_title': instance.original_title,
      'backdrop_path': instance.backdrop_path,
      'poster_path': instance.poster_path,
      'homepage': instance.homepage,
      'overview': instance.overview,
      'release_date': instance.release_date,
      'vote_average': instance.vote_average,
    };
