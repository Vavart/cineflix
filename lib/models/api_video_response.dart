// Basic imports
import 'package:cineflix/api/endpoint.dart';
import 'dart:convert';
import 'dart:async';

// Json package import
import 'package:json_annotation/json_annotation.dart';

// HTTP package import
import 'package:http/http.dart' as http;

// Environment variables import
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Models import
import 'package:cineflix/models/video.dart';


// Part file import
part 'api_video_response.g.dart';

@JsonSerializable()
class APIVideoResponse {
  final int id;
  final List<Video> results;

  APIVideoResponse({
    required this.id,
    required this.results,
  });

  // This is the part where we convert the JSON to a Dart object
  factory APIVideoResponse.fromJson(Map<String, dynamic> json) =>
      _$APIVideoResponseFromJson(json);

  // fetchTrendyMovies() is a static method that returns a Future<List<MovieCardSimple>> (the list of trendy movies as cards)
  static Future<APIVideoResponse> fetchFirstVideoFromMovieID(int id) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/$id/videos", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return APIVideoResponse.fromJson(json.decode(resp.body));
  }
}