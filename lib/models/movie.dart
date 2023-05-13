// Basic imports
// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:math';

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
part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final int id;
  final String original_title;
  final String? backdrop_path;
  final String? poster_path;
  final String? homepage;
  final String overview;
  final String? release_date;
  final double vote_average;

  Movie({
    required this.id,
    required this.original_title,
    required this.backdrop_path,
    required this.poster_path,
    required this.homepage,
    required this.overview,
    required this.release_date,
    required this.vote_average,
  });

  // This is the part where we convert the JSON to a Dart object
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  // fetchTrendyMovies() is a static method that returns a Future<List<MovieCardSimple>> (the list of trendy movies as cards)
  static Future<Movie> fetchMovieById(int id) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/$id", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return Movie.fromJson(json.decode(resp.body));
  }

  static Future<Movie> fetchLastMovie() async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    var uri = await Endpoint.movieUri("/movie/latest", queryParameters: {
      "api_key": apiKey,
    });

    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw (resp.body);
    }

    return Movie.fromJson(json.decode(resp.body));
  }

  static Future<Movie> fetchRandomMovie(int maxID, List<String> watchedMovies) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file
    var apiKey = dotenv.env['API_KEY'];

    // While loop to get a random movie (until we get a 200 response)
    int statusCode = 404;
    http.Response resp = http.Response("", statusCode);

    while (statusCode != 200) {
      var randomID = Random().nextInt(maxID + 1); // Non-inclusive

      var uri = await Endpoint.movieUri("/movie/$randomID", queryParameters: {
        "api_key": apiKey,
      });

      resp = await http.get(uri);
      statusCode = resp.statusCode;

      // Sleep for 2 seconds to avoid getting rate limited
      sleep(const Duration(seconds: 2));
    }

    return Movie.fromJson(json.decode(resp.body));
  }
}
