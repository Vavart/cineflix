// Basic imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Pages imports
import 'movie_detail.dart';

// Models imports
import 'package:cineflix/models/movie.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => FavoritesStage();
}

class FavoritesStage extends State<Favorites> {
  // Shared preferences
  late SharedPreferences _prefs;

  // List of all favorite / watched movies id (will be fetched from the shared preferences)
  List<String> _favoriteMovies = [];
  List<String> _watchedMovies = [];

  // List of all favorite / watched movies data (will be fetched from the API)
  List<Movie> _favoriteMoviesData = [];
  List<Movie> _watchedMoviesData = [];

  // API url to get images
  final String _apiImageUrl = "https://image.tmdb.org/t/p/original";

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    // Init shared preferences
    await _initSharedPreferences();

    // Fetch the list of all favorite / watched movies id (from the shared preferences) if null, set it to an empty list by default
    _favoriteMovies = _prefs.getStringList("favorite_movies") ?? [];
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    // Fetch the according movie data from the shared preferences
    await _initFavoriteMovies();
    await _initWatchedMovies();
  }

  // Init shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Init the favorite / watched movies data from the API
  Future<void> _initFavoriteMovies() async {
    List<Movie> favoriteMoviesFromAPI = [];
    for (int i = 0; i < _favoriteMovies.length; i++) {
      Movie movie = await Movie.fetchMovieById(int.parse(_favoriteMovies[i]));
      favoriteMoviesFromAPI.add(movie);
    }

    setState(() => _favoriteMoviesData = favoriteMoviesFromAPI);
  }

  Future<void> _initWatchedMovies() async {
    List<Movie> watchedMoviesFromAPI = [];
    for (int i = 0; i < _watchedMovies.length; i++) {
      Movie movie = await Movie.fetchMovieById(int.parse(_watchedMovies[i]));
      watchedMoviesFromAPI.add(movie);
    }

    setState(() => _watchedMoviesData = watchedMoviesFromAPI);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _init();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: _renderPage(context),
        ),
      ),
    );
  }

  Widget _renderPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_6, bottom: BaseStyles.spacing_10),
      child: Column(
        children: [
          _renderHeader(context),
          _renderFavoriteMoviesList(context),
        ],
      ),
    );
  }

  Widget _renderHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_3, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: Text(
        "Your favorites movies",
        style: BaseStyles.h1,
      ),
    );
  }

  Widget _renderFavoriteMoviesList(BuildContext context) {
    return Column(
      children: [
        // Render the favorite movies
        for (int i = 0; i < _favoriteMovies.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                BaseStyles.spacing_3,
                BaseStyles.spacing_2,
                BaseStyles.spacing_3,
                BaseStyles.spacing_1),
            child: _complexMovieCardWithTrash(context, i),
          ),
      ],
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexMovieCardWithTrash(BuildContext context, int index) {
    return GestureDetector(
      onTap: () =>
          _navigationToMovieDetail(context, int.parse(_favoriteMovies[index])),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderMovieComplexCardImage(index),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            _renderMovieComplexCardInfo(context, index),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            _renderMovieComplexCardTrashIcon(index),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieComplexCardImage(int index) {
    Image image;
    if (_favoriteMoviesData[index].poster_path != null) {
      image = Image.network(
        _apiImageUrl + _favoriteMoviesData[index].poster_path!,
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    } else {
      image = Image.asset(
        "assets/images/no_movie_preview.png",
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
      child: image,
    );
  }

  Widget _renderMovieComplexCardInfo(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderMovieComplexCardTitle(index),
        _renderMovieComplexCardIcons(index),
        _renderMovieComplexCardDescription(context, index),
      ],
    );
  }

  Widget _renderMovieComplexCardTitle(int index) {
    return SizedBox(
      width: 150.0,
      child: Text(
        textAlign: TextAlign.left,
        _favoriteMoviesData[index].original_title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: BaseStyles.boldText,
      ),
    );
  }

  Widget _renderMovieComplexCardIcons(int index) {
    return Row(
      children: [
        _renderMovieComplexCardRating(index),
        _renderMovieComplexCardWatchIcon(index),
      ],
    );
  }

  Widget _renderMovieComplexCardRating(int index) {
    int rating = (_favoriteMoviesData[index].vote_average * 10).round();
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Row(
        children: [
          Icon(
            FeatherIcons.star,
            color: BaseStyles.yellowStar,
          ),
          // Add a space between the icon and the text
          const SizedBox(width: BaseStyles.spacing_1),
          Text(
            "$rating %",
            style: BaseStyles.boldSmallYellowText,
          ),
        ],
      ),
    );
  }

  Widget _renderMovieComplexCardWatchIcon(int index) {
    // Check if the movie is watched or not to display the right icon
    IconData icon = _watchedMovies.contains(_favoriteMovies[index])
        ? FeatherIcons.eye
        : FeatherIcons.eyeOff;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Icon(
        icon,
        color: BaseStyles.lightBlue,
      ),
    );
  }

  Widget _renderMovieComplexCardDescription(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 150.0
          : MediaQuery.of(context).size.width * 0.6,
      child: Text(
        _favoriteMoviesData[index].overview,
        style: BaseStyles.smallText,
        textAlign: TextAlign.left,
        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _renderMovieComplexCardTrashIcon(int index) {
    return TextButton(
      // ignore: avoid_print
      onPressed: () => print("Trash icon pressed for movie $index"),
      style: BaseStyles.ctaButtonStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_2),
        child: Icon(
          FeatherIcons.trash2,
          color: BaseStyles.candy,
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
