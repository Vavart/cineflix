// Imports
import 'package:flutter_test/flutter_test.dart';

// Models import
import 'package:cineflix/models/api_search_response.dart';
import 'package:cineflix/models/movie.dart';

void main() {
  test("test get random top rated movie", () async {
    // Get top rated movies
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchTopRatedMovies();
    List<Movie> movies = apiSearchResponse.results;

    // Tests
    expect(movies[0].original_title, "The Godfather");
  });

  test("test get similar movie", () async {
    // Get similar movies
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchSimilarMovies(502356);
    List<Movie> movies = apiSearchResponse.results;

    // Tests
    expect(movies[0].id, 60898);
  });

  // test("test get random movie", () async {
  //   // Get last movie id (to define the range)
  //   Movie lastMovie = await Movie.fetchLastMovie();
  // });
}
