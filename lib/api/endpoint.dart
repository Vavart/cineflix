// Basic imports
import 'dart:core';

// Package imports
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoint {
/*
Possible paths : 
/movie/{id}?api_key={api_key} (GET movie details)
/movie/popular?api_key={api_key} (GET popular movies)
/search/movie?api_key={api_key}&query={query} (GET search movies)
/movie/{id}/credits?api_key={api_key} (GET movie credits)
*/

  // Async because we need to load the .env file
  static Future<Uri> movieUri(String path,
      {required Map<String, dynamic> queryParameters}) async {
    // Load .env file
    await dotenv.load(fileName: ".env");

    // Get variables from .env file 
    var apiScheme = dotenv.env['API_SCHEME'];
    var apiHost = dotenv.env['API_HOST'];
    var prefix = dotenv.env['API_PREFIX'];
    // => https://api.themoviedb.org/3


    final uri = Uri(
      scheme: apiScheme,
      host: apiHost,
      path: prefix! + path,
      queryParameters: queryParameters,
    );

    return uri;
  }
}
