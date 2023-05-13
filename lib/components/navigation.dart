// Basic import
import 'package:flutter/material.dart';

// Pages imports
import 'package:cineflix/pages/movie_detail.dart';

class Navigation {
  // Navigate to the movie detail page
  static void navigationToMovieDetail(BuildContext context, int movieID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: movieID)));
  }
}
