// Basic imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

class FavoritesStage extends State<Favorites> with TickerProviderStateMixin {
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

  // Callbacks for the CTAs
  void _handleRemoveFromFavorites(int movieIndex) async {
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
                        ? _renderNoFavoritesText()
                        : _renderFavoriteMoviesList(context),
                  ),
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _watchedMovies.isEmpty
                        ? _renderNoWatchedText()
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

  /// *********************************************************************************************** ///
  /// ***************************** Render no favorites / watched texts ***************************** ///
  /// *********************************************************************************************** ///

  Widget _renderNoFavoritesText() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_10),
      child: Row(
        children: [
          // Flexible to make the text wrap if the search query is too long
          Flexible(
            child: Text(
              "You didn't add any movie to your favorites 😢\n\nTry to search for a movie you love !",
              style: BaseStyles.text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderNoWatchedText() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Flexible to make the text wrap if the search query is too long
          Flexible(
            child: Text(
              "You didn't add any movie to your watched list 😢\n\nTry to search for a movie !",
              style: BaseStyles.text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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
              child: _complexFavoriteMovieCardWithTrash(context, i),
            ),
        ],
      ),
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexFavoriteMovieCardWithTrash(BuildContext context, int index) {
    return GestureDetector(
      onTap: () =>
          _navigationToMovieDetail(context, int.parse(_favoriteMovies[index])),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderFavoriteMovieComplexCardImage(index),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            _renderFavoriteMovieComplexCardInfo(context, index),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            _renderFavoriteMovieComplexCardTrashIcon(index),
          ],
        ),
      ),
    );
  }

  Widget _renderFavoriteMovieComplexCardImage(int index) {
    // If the movie has a poster
    if (_favoriteMoviesData[index].poster_path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: CachedNetworkImage(
          imageUrl: _apiImageUrl + _favoriteMoviesData[index].poster_path!,
          placeholder: (context, url) {
            return Center(
              child: SizedBox(
                  width: BaseStyles.spacing_5,
                  height: BaseStyles.spacing_5,
                  child: CircularProgressIndicator(
                    color: BaseStyles.lightBlue,
                    strokeWidth: BaseStyles.spacing_1,
                  )),
            );
          },

          // If the image fails to load display a default image instead
          errorWidget: (context, url, error) {
            return const Image(
              image: AssetImage(
                "assets/images/no_movie_preview.png",
              ),
              width: MovieStyles.movieCardImgWidth,
              height: MovieStyles.movieCardImgHeight,
              fit: BoxFit.cover,
            );
          },
          width: MovieStyles.movieCardImgWidth,
          height: MovieStyles.movieCardImgHeight,
          fit: BoxFit.cover,
        ),
      );

      // If the movie has no poster
    } else {
      Image img = const Image(
        image: AssetImage(
          "assets/images/no_movie_preview.png",
        ),
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: img,
      );
    }
  }

  Widget _renderFavoriteMovieComplexCardInfo(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderFavoriteMovieComplexCardTitle(index),
        _renderFavoriteMovieComplexCardIcons(index),
        _renderFavoriteMovieComplexCardDescription(context, index),
      ],
    );
  }

  Widget _renderFavoriteMovieComplexCardTitle(int index) {
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

  Widget _renderFavoriteMovieComplexCardIcons(int index) {
    return Row(
      children: [
        _renderFavoriteMovieComplexCardRating(index),
        _renderFavoriteMovieComplexCardWatchIcon(index),
      ],
    );
  }

  Widget _renderFavoriteMovieComplexCardRating(int index) {
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

  Widget _renderFavoriteMovieComplexCardWatchIcon(int index) {
    // Check if the movie is watched or not to display the right icon
    IconData icon = _watchedMovies.contains(_favoriteMovies[index])
        ? FeatherIcons.checkCircle
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

  Widget _renderFavoriteMovieComplexCardDescription(
      BuildContext context, int index) {
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

  Widget _renderFavoriteMovieComplexCardTrashIcon(int index) {
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
      onTap: () =>
          _navigationToMovieDetail(context, int.parse(_watchedMovies[index])),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderWatchedMovieComplexCardImage(index),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            _renderWatchedMovieComplexCardInfo(context, index),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            _renderWatchedMovieComplexCardTrashIcon(index),
          ],
        ),
      ),
    );
  }

  Widget _renderWatchedMovieComplexCardImage(int index) {
    // If the movie has a poster
    if (_watchedMoviesData[index].poster_path != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: CachedNetworkImage(
          imageUrl: _apiImageUrl + _watchedMoviesData[index].poster_path!,
          placeholder: (context, url) {
            return Center(
              child: SizedBox(
                  width: BaseStyles.spacing_5,
                  height: BaseStyles.spacing_5,
                  child: CircularProgressIndicator(
                    color: BaseStyles.lightBlue,
                    strokeWidth: BaseStyles.spacing_1,
                  )),
            );
          },

          // If the image fails to load display a default image instead
          errorWidget: (context, url, error) {
            return const Image(
              image: AssetImage(
                "assets/images/no_movie_preview.png",
              ),
              width: MovieStyles.movieCardImgWidth,
              height: MovieStyles.movieCardImgHeight,
              fit: BoxFit.cover,
            );
          },
          width: MovieStyles.movieCardImgWidth,
          height: MovieStyles.movieCardImgHeight,
          fit: BoxFit.cover,
        ),
      );

      // If the movie has no poster
    } else {
      Image img = const Image(
        image: AssetImage(
          "assets/images/no_movie_preview.png",
        ),
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: img,
      );
    }
  }

  Widget _renderWatchedMovieComplexCardInfo(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderWatchedMovieComplexCardTitle(index),
        _renderWatchedMovieComplexCardIcons(index),
        _renderWatchedMovieComplexCardDescription(context, index),
      ],
    );
  }

  Widget _renderWatchedMovieComplexCardTitle(int index) {
    return SizedBox(
      width: 150.0,
      child: Text(
        textAlign: TextAlign.left,
        _watchedMoviesData[index].original_title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: BaseStyles.boldText,
      ),
    );
  }

  Widget _renderWatchedMovieComplexCardIcons(int index) {
    return Row(
      children: [
        _renderWatchedMovieComplexCardRating(index),
        _renderWatchedMovieComplexCardWatchIcon(index),
      ],
    );
  }

  Widget _renderWatchedMovieComplexCardRating(int index) {
    int rating = (_watchedMoviesData[index].vote_average * 10).round();
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

  Widget _renderWatchedMovieComplexCardWatchIcon(int index) {
    // Check if the movie is watched or not to display the right icon (normally, it should be watched all the time)
    IconData icon = _watchedMovies.contains(_watchedMovies[index])
        ? FeatherIcons.checkCircle
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

  Widget _renderWatchedMovieComplexCardDescription(
      BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 150.0
          : MediaQuery.of(context).size.width * 0.6,
      child: Text(
        _watchedMoviesData[index].overview,
        style: BaseStyles.smallText,
        textAlign: TextAlign.left,
        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _renderWatchedMovieComplexCardTrashIcon(int index) {
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

  // Navigation methods
  void _navigationToMovieDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }
}
