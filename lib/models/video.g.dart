// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
      key: json['key'] as String,
      site: json['site'] as String,
      type: json['type'] as String,
      official: json['official'] as bool,
      size: json['size'] as int,
    );

// ignore: unused_element
Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'key': instance.key,
      'site': instance.site,
      'type': instance.type,
      'size': instance.size,
      'official': instance.official,
    };
