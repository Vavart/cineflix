// Basic imports
// ignore_for_file: non_constant_identifier_names

import 'package:cineflix/api/endpoint.dart';
import 'dart:convert';
import 'dart:async';

// Json package import
import 'package:json_annotation/json_annotation.dart';

// HTTP package import
import 'package:http/http.dart' as http;

// Environment variables import
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  static Future<Cast> fetchCast(int id) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/$id/credits", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return Cast.fromJson(json.decode(resp.body));
  }
}