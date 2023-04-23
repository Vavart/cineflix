// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_cast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APICastResponse _$APICastResponseFromJson(Map<String, dynamic> json) =>
    APICastResponse(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => Cast.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

// ignore: unused_element
Map<String, dynamic> _$APICastResponseToJson(APICastResponse instance) =>
    <String, dynamic>{
      'cast': instance.cast,
    };
