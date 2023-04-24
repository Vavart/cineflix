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
import 'package:cineflix/models/movie.dart';

// Part file import
part 'api_search_response.g.dart';

@JsonSerializable()
class APISearchResponse {
  final List<Movie> results;

  APISearchResponse({
    required this.results,
  });

  // This is the part where we convert the JSON to a Dart object
  factory APISearchResponse.fromJson(Map<String, dynamic> json) =>
      _$APISearchResponseFromJson(json);

  // fetchTrendyMovies() is a static method that returns a Future<List<MovieCardSimple>> (the list of trendy movies as cards)
  static Future<APISearchResponse> fetchMovieBySearch(String query) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/search/movie",
        queryParameters: {"api_key": apiKey, "query": query});

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return APISearchResponse.fromJson(json.decode(resp.body));
  }

  static Future<APISearchResponse> fetchPopularMovies() async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/popular", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return APISearchResponse.fromJson(json.decode(resp.body));
  }

  static Future<APISearchResponse> fetchTopRatedMovies() async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/top_rated", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return APISearchResponse.fromJson(json.decode(resp.body));
  }

  static Future<APISearchResponse> fetchSimilarMovies(int id) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri =
        await Endpoint.movieUri("/movie/$id/recommendations", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return APISearchResponse.fromJson(json.decode(resp.body));
  }
}
