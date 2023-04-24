// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIVideoResponse _$APIVideoResponseFromJson(Map<String, dynamic> json) =>
    APIVideoResponse(
      id: json['id'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => Video.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

// ignore: unused_element
Map<String, dynamic> _$APIVideoResponseToJson(APIVideoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'results': instance.results,
    };
