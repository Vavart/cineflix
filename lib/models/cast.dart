// Basic imports
// ignore_for_file: non_constant_identifier_names

// Json package import
import 'package:json_annotation/json_annotation.dart';


// Part file import
part 'cast.g.dart';

@JsonSerializable()
class Cast {
  final int id;
  final String name;
  final String character;
  final String? profile_path;

  Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.profile_path,
  });

  // This is the part where we convert the JSON to a Dart object
  factory Cast.fromJson(Map<String, dynamic> json) => _$CastFromJson(json);

  // fetchTrendyMovies() is a static method that returns a Future<List<MovieCardSimple>> (the list of trendy movies as cards)
}