// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APISearchResponse _$APISearchResponseFromJson(Map<String, dynamic> json) =>
    APISearchResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

// ignore: unused_element
Map<String, dynamic> _$APISearchResponseToJson(APISearchResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
    };
