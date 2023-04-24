// Basic imports
// ignore_for_file: non_constant_identifier_names

// Json package import
import 'package:json_annotation/json_annotation.dart';


// Part file import
part 'video.g.dart';

@JsonSerializable()
class Video {
  final String key;
  final String site;
  final String type;
  final bool official;

  Video({
    required this.key,
    required this.site,
    required this.type,
    required this.official,
  });

  // This is the part where we convert the JSON to a Dart object
  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

}