// Basic imports
import 'dart:io';
import 'package:cineflix/models/api_search_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:cineflix/styles/recommandation.dart';
import 'package:feather_icons/feather_icons.dart';

// Pages imports
import 'movie_detail.dart';

// Models import
import 'package:cineflix/models/movie.dart';

class Recommandation extends StatefulWidget {
  const Recommandation({super.key});

  @override
  RecommandationState createState() => RecommandationState();
}

class RecommandationState extends State<Recommandation> {
  // Current tab index (0: Classic page, 1: Movie suggestion)
  int _currentIndex = 0;

  // Shared preferences
  late SharedPreferences _prefs;

  // List of all favorite / watched movies id (will be fetched from the shared preferences)
  List<String> _favoriteMovies = [];
  List<String> _watchedMovies = [];

  // List of recommended movies
  List<Movie> _movies = [];

  // Boolean to know if the movies are loading
  bool _isLoading = true;

  // API url to get images
  final String _apiImageUrl = "https://image.tmdb.org/t/p/original";

  @override
  void initState() {
    super.initState();
  }

  // Load recommended movies
  void _loadMovies() async {
    // Init shared preferences
    await _initSharedPreferences();

    // Fetch the list of all favorite / watched movies id (from the shared preferences) if null, set it to an empty list by default
    _favoriteMovies = _prefs.getStringList("favorite_movies") ?? [];
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    // Fetch the list of recommended movies
    _movies = await _fetchRecommendedMovies(_favoriteMovies, _watchedMovies);

    setState(() => _isLoading = false);
  }

  // Init shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // fetchRecommendedMovies() is a method that returns a Future<List<Movie>> (the list of recommended movies)
  Future<List<Movie>> _fetchRecommendedMovies(
      List<String> favoriteMovies, List<String> watchedMovies) async {
    // Create a list of recommended movies (will be returned at the end of the function)
    List<Movie> recommendedMovies = [];

    // Is the user has favorite movies (get a random movie from the list of favorite movies, to get similar movies)
    if (favoriteMovies.isNotEmpty) {
      int randomFavoriteMovieID = _fetchRandomMovie(favoriteMovies);
      Movie movie = await _fetchRandomSimilarMovie(randomFavoriteMovieID);

      while (watchedMovies.contains(movie.id.toString())) {
        // Sleep for 2 seconds to avoid too many requests
        sleep(const Duration(seconds: 2));

        // Re-fetch a random similar movie
        movie = await _fetchRandomSimilarMovie(randomFavoriteMovieID);
      }

      // Add the movie to the list of recommended movies
      recommendedMovies.add(movie);
    }

    // Get a random top rated movie
    Movie movie = await _fetchRandomTopRatedMovies();

    while (watchedMovies.contains(movie.id.toString())) {
      // Sleep for 2 seconds to avoid too many requests
      sleep(const Duration(seconds: 2));

      // Re-fetch a random top rated movie
      movie = await _fetchRandomTopRatedMovies();
    }

    // Add the movie to the list of recommended movies
    recommendedMovies.add(movie);

    // Return the list of recommended movies
    return recommendedMovies;
  }

  // Fetch top rated movies
  Future<Movie> _fetchRandomTopRatedMovies() async {
    // Get the list of top rated movies
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchTopRatedMovies();
    List<Movie> topRatedMovies = apiSearchResponse.results;
    int randomTopRatedMovieID = Random().nextInt(topRatedMovies.length);

    // Return the list of top rated movies
    return topRatedMovies[randomTopRatedMovieID];
  }

  // Get a random movie from a list of movies id (will be used to get a random favorite movie)
  int _fetchRandomMovie(List<String> moviesID) {
    // Get a random movie id
    int randomMovieID = Random().nextInt(moviesID.length); // Non-inclusive

    // Return the movie
    return int.parse(moviesID[randomMovieID]);
  }

  // Fetch similar movie from a movie id (will be used to get similar movies from a favorite movie)
  Future<Movie> _fetchRandomSimilarMovie(int movieID) async {
    // Get the list of similar movies
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchSimilarMovies(movieID);
    List<Movie> similarMovies = apiSearchResponse.results;

    // Get a random similar movie
    int randomSimilarMovieID =
        Random().nextInt(similarMovies.length); // Non-inclusive

    // Return the random similar movie
    return similarMovies[randomSimilarMovieID];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IndexedStack(
        index: _currentIndex,
        children: [
          _renderClassicPage(),
          // If the movies are loading, render the loading widget
          _isLoading ? _renderLoading() : _renderMovieSuggestion(),
        ],
      ),
    );
  }

  // Loader
  Widget _renderLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          backgroundColor: BaseStyles.darkShade_1,
          color: BaseStyles.lightBlue,
        ),
      ],
    );
  }

  /// ******************************************************************************************** ///
  /// ***************************** Render movies suggestion widget  ***************************** ///
  /// ******************************************************************************************** ///

  Widget _renderMovieSuggestion() {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_9, bottom: BaseStyles.spacing_6),
      child: Column(
        children: [
          _renderMovieSuggHeader(),
          _renderSuggestions(),
          _renderProTip(),
          _renderMovieSuggCTA(),
        ],
      ),
    );
  }

  Widget _renderMovieSuggHeader() {
    return Column(
      children: [
        _renderMoviesSuggTitle(),
        _renderMoviesSuggIndicationText(),
      ],
    );
  }

  Widget _renderMoviesSuggTitle() {
    return Text("Look what we got for you", style: BaseStyles.h2);
  }

  Widget _renderMoviesSuggIndicationText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_3, BaseStyles.spacing_3, BaseStyles.spacing_0),
      child: Text(
        "Here are some movie suggestions based on your preferences.\nHope you will like them !",
        style: BaseStyles.text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderSuggestions() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: BaseStyles.spacing_6, horizontal: BaseStyles.spacing_0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _renderSuggestionCards(),
      ),
    );
  }

  List<Widget> _renderSuggestionCards() {
    List<Widget> suggestionCards = [];

    for (int i = 0; i < _movies.length; i++) {
      suggestionCards.add(_renderSuggestionCard(_movies[i], i));
    }
    return suggestionCards;
  }

  Widget _renderSuggestionCard(Movie movie, int index) {
    return GestureDetector(
      onTap: () => _navigationToMovieDetail(context, movie.id),
      child: Column(
        children: [
          _renderSuggestionCardImage(movie),
          _renderSuggestionCardTitle(movie.original_title),
        ],
      ),
    );
  }

  Widget _renderSuggestionCardImage(Movie movie) {
    ImageProvider image = const AssetImage(
      "assets/images/no_movie_preview.png",
    );

    if (movie.backdrop_path != null) {
      image = NetworkImage(
        _apiImageUrl + movie.backdrop_path!,
      );
    }

    return Container(
      width: MovieStyles.movieCardImgWidth,
      height: MovieStyles.movieCardImgHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _renderSuggestionCardTitle(String title) {
    return SizedBox(
      width: MovieStyles.simpleMovieCardTitleWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: BaseStyles.spacing_1),
        child: Text(
          title,
          style: BaseStyles.boldSmallText,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _renderProTip() {
    return Padding(
      padding: const EdgeInsets.only(bottom: BaseStyles.spacing_3),
      child: Text(
        "Pro tip : consider adding movies to your favorites to get a more personalized suggestions !",
        style: BaseStyles.smallText,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderMovieSuggCTA() {
    return TextButton(
      style: BaseStyles.ctaButtonStyle,
      onPressed: () => setState(() {
        _currentIndex = 0;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: BaseStyles.spacing_2, horizontal: BaseStyles.spacing_3),
        child: Text(
          "Make another suggestion",
          style: BaseStyles.text,
        ),
      ),
    );
  }

  /// ********************************************************************************** ///
  /// ***************************** Render classic widget  ***************************** ///
  /// ********************************************************************************** ///

  Widget _renderClassicPage() {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_9, bottom: BaseStyles.spacing_6),
      child: Column(
        children: [
          _renderClassicHeader(),
          _renderClassicDiscoverIcon(),
          _renderClassicSuggestionCTA(),
        ],
      ),
    );
  }

  Widget _renderClassicHeader() {
    return Column(
      children: [
        _renderClassicTitle(),
        _renderClassicIndicationText(),
      ],
    );
  }

  Widget _renderClassicTitle() {
    return Text("Let's make a guess", style: BaseStyles.h2);
  }

  Widget _renderClassicIndicationText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_3, BaseStyles.spacing_3, BaseStyles.spacing_0),
      child: Text(
        "Our AI is based on your favorites movies , and don't worry, it will not be something you've already watched !",
        style: BaseStyles.text,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderClassicDiscoverIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: BaseStyles.spacing_7, horizontal: BaseStyles.spacing_0),
      child: Icon(
        FeatherIcons.compass,
        size: AIStyles.aiCTAIconSize,
        color: BaseStyles.lightBlue,
      ),
    );
  }

  Widget _renderClassicSuggestionCTA() {
    return TextButton(
      style: BaseStyles.ctaButtonStyle,
      onPressed: () => setState(() {
        _currentIndex = 1;
        _loadMovies();
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: BaseStyles.spacing_2, horizontal: BaseStyles.spacing_3),
        child: Text(
          "Suggest me a movie",
          style: BaseStyles.text,
        ),
      ),
    );
  }

  // Navigation methods
  void _navigationToMovieDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }
}
