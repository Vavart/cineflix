// Imports
import 'package:flutter_test/flutter_test.dart';

// Models import
import 'package:cineflix/models/api_search_response.dart';
import 'package:cineflix/models/api_cast_response.dart';
import 'package:cineflix/models/cast.dart';
import 'package:cineflix/models/movie.dart';
import 'package:cineflix/models/api_video_response.dart';
import 'package:cineflix/models/video.dart';

// Test
void main() {
  test("test get trendy movies", () async {
    // Get popular movies
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchPopularMovies();
    List<Movie> movies = apiSearchResponse.results;

    // Tests
    expect(movies, isNotNull);
    expect(movies, isNotEmpty);
    expect(movies.length, 20);
  });

  test("test get movie by id img not null", () async {
    // Get movie by id
    Movie movie = await Movie.fetchMovieById(550);

    // Tests
    expect(movie.id, 550);
    expect(movie.backdrop_path, isNotNull);
    expect(movie.original_title, isNotNull);
    expect(movie.overview, isNotNull);
    expect(movie.release_date, isNotNull);
    expect(movie.vote_average, isNotNull);
  });
  test("test get movie by id img null", () async {
    // Get movie by id
    Movie movie = await Movie.fetchMovieById(324825);

    // Tests
    expect(movie.id, 324825);
    expect(movie.backdrop_path, isNull);
    expect(movie.original_title, isNotNull);
    expect(movie.overview, isNotNull);
    expect(movie.release_date, isNotNull);
    expect(movie.vote_average, isNotNull);
  });

  test("test get movie by search", () async {
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchMovieBySearch("the fugitives");
    List<Movie> movies = apiSearchResponse.results;

    // Tests
    expect(movies, isNotEmpty);
    expect(movies[0].original_title, "The Fugitives");
    expect(movies[0].release_date, "1963-01-01");
  });

  test("test casting", () async {
    APICastResponse apiCastResponse =
        await APICastResponse.fetchCastByMovieId(603692);
    List<Cast> cast = apiCastResponse.cast;

    // Tests
    expect(cast, isNotEmpty);
    expect(cast[0].name, "Keanu Reeves");
    expect(cast[0].character, "John Wick");
    expect(cast[0].profile_path, "/4D0PpNI0kmP58hgrwGC3wCjxhnm.jpg");
  });

  test("test get movie poster (backdrop path)", () async {
    // Get movie by id
    Movie movie = await Movie.fetchMovieById(603692);

    // Tests
    expect(movie.backdrop_path, isNotNull);
    expect(movie.backdrop_path, "/h8gHn0OzBoaefsYseUByqsmEDMY.jpg");
  });

  test("test get videos", () async {
    // Get videos of Mario movie
    APIVideoResponse apiVideoResponse =
        await APIVideoResponse.fetchFirstVideoFromMovieID(502356);
    List<Video> videos = apiVideoResponse.results;
    List<Video> filteredVideos = videos.where((video) => video.site == "YouTube" && video.type == "Trailer" && video.official == true).toList();

    // Tests
    // We want the vidao that is :
    // - a trailer
    // - on youtube
    // - official

    for (var video in filteredVideos) {
      expect(video.site, "YouTube");
      expect(video.type, "Trailer");
      expect(video.official, true);
    }

  });
}
