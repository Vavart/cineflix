// Basic imports
import 'package:cineflix/components/complex_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models imports
import 'package:cineflix/models/movie.dart';

// Components imports
import 'package:cineflix/components/favorite_card_builder.dart';
import 'package:cineflix/components/navigation.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => FavoritesStage();
}

class FavoritesStage extends State<Favorites> with TickerProviderStateMixin {
  /// ************************************************************************************ ///
  /// ***************************** Utils and initialization ***************************** ///
  /// ************************************************************************************ ///

  // Shared preferences
  late SharedPreferences _prefs;

  // List of all favorite / watched movies id (will be fetched from the shared preferences)
  List<String> _favoriteMovies = [];
  List<String> _watchedMovies = [];

  // List of all favorite / watched movies data (will be fetched from the API)
  List<Movie> _favoriteMoviesData = [];
  List<Movie> _watchedMoviesData = [];

  // Tab controller
  late TabController _tabController = TabController(length: 2, vsync: this);

  // Is loading
  bool _isLoading = true;

  /// ***************************** Animation ***************************** ///

  // Animation variables (init in the initState)
  late AnimationController _animationController;
  late Animation<double> _animation;

  void _startAnimation() {
    _animationController.reset();
    _animationController.animateTo(1.0, duration: const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _init();

    // Tab controller
    _tabController = TabController(length: 2, vsync: this);

    // Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void _init() async {
    setState(() => _isLoading = true);

    // Init shared preferences
    await _initSharedPreferences();

    // Fetch the list of all favorite / watched movies id (from the shared preferences) if null, set it to an empty list by default
    _favoriteMovies = _prefs.getStringList("favorite_movies") ?? [];
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    // Fetch the according movie data from the shared preferences
    await _initWatchedMovies();
    await _initFavoriteMovies();

    setState(() => _isLoading = false);
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

  /// ********************************************************************************* ///
  /// ***************************** Callbacks & snackbars ***************************** ///
  /// ********************************************************************************* ///

  // Callbacks for the CTAs
  void _handleRemoveFromFavorites(int movieIndex) async {
    // Remove all previous snackbars (if any)
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // Keep the movie id in case of undo
    final String movieId = _favoriteMoviesData[movieIndex].id.toString();

    // Remove the movie from the list of all favorite movies id
    _favoriteMovies.remove(_favoriteMoviesData[movieIndex].id.toString());

    // Save the list of all favorite movies id (in the shared preferences)
    _prefs.setStringList("favorite_movies", _favoriteMovies);

    // Update the UI state dynamically
    _init();

    // Display a snackbar to provide feedback to the user (favorite added / removed) and allow him to undo
    final snackBar = SnackBar(
      backgroundColor: BaseStyles.darkShade_1,
      content: Text(
          "${_favoriteMoviesData[movieIndex].original_title} has been removed from your favorites",
          style: BaseStyles.snackBarText),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        textColor: BaseStyles.lightBlue,
        label: 'Undo',
        onPressed: () {
          // Add the deleted movie into the list of all favorite movies id
          _favoriteMovies.add(movieId.toString());

          // Save the list of all favorite movies id (in the shared preferences)
          _prefs.setStringList("favorite_movies", _favoriteMovies);

          // Update the UI state dynamically
          _init();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleRemoveFromWatchList(int movieIndex) async {
    // Remove all previous snackbars (if any)
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    // Keep the movie id in case of undo
    final String movieId = _watchedMoviesData[movieIndex].id.toString();

    // Remove the movie from the list of all watched movies id
    _watchedMovies.remove(_watchedMoviesData[movieIndex].id.toString());

    // Save the list of all watched movies id (in the shared preferences)
    _prefs.setStringList("watched_movies", _watchedMovies);

    // Update the UI state dynamically
    _init();

    // Display a snackbar to provide feedback to the user (watched added / removed) and allow him to undo
    final snackBar = SnackBar(
      backgroundColor: BaseStyles.darkShade_1,
      content: Text(
          "${_watchedMoviesData[movieIndex].original_title} has been removed from your watch list",
          style: BaseStyles.snackBarText),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        textColor: BaseStyles.lightBlue,
        label: 'Undo',
        onPressed: () {
          // Add the deleted movie into the list of all watched movies id
          _watchedMovies.add(movieId.toString());

          // Save the list of all watched movies id (in the shared preferences)
          _prefs.setStringList("watched_movies", _watchedMovies);

          // Update the UI state dynamically
          _init();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// *********************************************************************** ///
  /// ***************************** Render page ***************************** ///
  /// *********************************************************************** ///

  // Render the page (impossible to use a component widget because of the tab controller)
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: BaseStyles.spacing_8),
        child: Center(
          child: SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircularProgressIndicator(
              backgroundColor: BaseStyles.darkShade_1,
              color: BaseStyles.darkBlue,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          heroTag: "refresh",
          onPressed: () async {
            _startAnimation();
            _init();
          },
          backgroundColor: BaseStyles.darkBlue,
          child: RotationTransition(
              turns: _animation, child: const Icon(FeatherIcons.refreshCw)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: BaseStyles.spacing_6),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    icon: Icon(FeatherIcons.heart),
                    text: "Favorites",
                  ),
                  Tab(
                    icon: Icon(FeatherIcons.checkCircle),
                    text: "Watched",
                  ),
                ],
                labelStyle: BaseStyles.text,
                indicatorColor: BaseStyles.lightBlue,
              ),
              Expanded(
                child: TabBarView(controller: _tabController, children: [
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _favoriteMovies.isEmpty
                        // ? _renderNoFavoritesText()
                        ? FavoriteCardBuilder.renderNoFavoritesOrWatchedText(
                            true)
                        : _renderFavoriteMoviesList(context),
                  ),
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _watchedMovies.isEmpty
                        ? FavoriteCardBuilder.renderNoFavoritesOrWatchedText(
                            false)
                        : _renderWatchedMoviesList(context),
                  ),
                ]),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// ******************************************************************************** ///
  /// ***************************** Render favorite page ***************************** ///
  /// ******************************************************************************** ///

  Widget _renderFavoriteMoviesList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_2, bottom: BaseStyles.spacing_10),
      child: Column(
        children: [
          // Render the favorite movies
          for (int i = 0; i < _favoriteMovies.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  BaseStyles.spacing_3,
                  BaseStyles.spacing_2,
                  BaseStyles.spacing_3,
                  BaseStyles.spacing_1),
              child: _complexFavoriteMovieCard(context, i),
            ),
        ],
      ),
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexFavoriteMovieCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigation.navigationToMovieDetail(
          context, int.parse(_favoriteMovies[index])),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            // Movie image
            ComplexCardBuilder.renderMovieComplexCardImage(
                _favoriteMoviesData[index].poster_path),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            // Movie info
            ComplexCardBuilder.renderMovieComplexCardInfo(
                _favoriteMoviesData[index].original_title,
                _favoriteMoviesData[index].vote_average,
                _watchedMovies.contains(_favoriteMovies[index]),
                _favoriteMoviesData[index].overview),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            // Trash icon (to remove the movie from the favorite list)
            _renderRemoveFavoriteBtn(index),
          ],
        ),
      ),
    );
  }

  // Render the trash icon to remove the movie from the favorite list (impossible to use component because of the onPressed method)
  Widget _renderRemoveFavoriteBtn(int index) {
    return TextButton(
      onPressed: () {
        _handleRemoveFromFavorites(index);
      },
      style: BaseStyles.ctaButtonStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_2),
        child: Icon(
          FeatherIcons.xCircle,
          color: BaseStyles.candy,
        ),
      ),
    );
  }

  /// ******************************************************************************* ///
  /// ***************************** Render watched page ***************************** ///
  /// ******************************************************************************* ///

  Widget _renderWatchedMoviesList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_2, bottom: BaseStyles.spacing_10),
      child: Column(
        children: [
          // Render the favorite movies
          for (int i = 0; i < _watchedMovies.length; i++)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  BaseStyles.spacing_3,
                  BaseStyles.spacing_2,
                  BaseStyles.spacing_3,
                  BaseStyles.spacing_1),
              child: _complexWatchedMovieCardWithTrash(context, i),
            ),
        ],
      ),
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexWatchedMovieCardWithTrash(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigation.navigationToMovieDetail(
          context, int.parse(_watchedMovies[index])),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            // Movie image
            ComplexCardBuilder.renderMovieComplexCardImage(
                _watchedMoviesData[index].poster_path),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            // Movie info
            ComplexCardBuilder.renderMovieComplexCardInfo(
                _watchedMoviesData[index].original_title,
                _watchedMoviesData[index].vote_average,
                true,
                _watchedMoviesData[index].overview),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            // Trash icon (to remove the movie from the favorite list)
            _renderRemoveWatchedBtn(index),
          ],
        ),
      ),
    );
  }

  Widget _renderRemoveWatchedBtn(int index) {
    return TextButton(
      onPressed: () => _handleRemoveFromWatchList(index),
      style: BaseStyles.ctaButtonStyle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_2),
        child: Icon(
          FeatherIcons.eyeOff,
          color: BaseStyles.candy,
        ),
      ),
    );
  }
}
