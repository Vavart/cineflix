// Basic imports
import 'package:cineflix/components/simple_card_builder.dart';
import 'package:cineflix/models/api_video_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models import
import 'package:cineflix/models/movie.dart';
import 'package:cineflix/models/api_cast_response.dart';
import 'package:cineflix/models/cast.dart';
import 'package:cineflix/models/video.dart';

// Components imports
import 'package:cineflix/components/utils.dart';

class MovieDetail extends StatefulWidget {
  // Movie ID
  final int movieID;
  const MovieDetail({super.key, required this.movieID});

  @override
  // ignore: no_logic_in_create_state
  createState() => MovieDetailState(movieID);
}

class MovieDetailState extends State<MovieDetail> {
  /// ************************************************************************************ ///
  /// ***************************** Utils and initialization ***************************** ///
  /// ************************************************************************************ ///

  // Movie ID (will be set from the constructor)
  int movieID;

  // Shared preferences
  late SharedPreferences _prefs;

  // List of all favorite / watched movies id (will be fetched from the shared preferences)
  List<String> _favoriteMovies = [];
  List<String> _watchedMovies = [];

  // Usefull variables for the UI state of the page (favorite / watched state) (will be set from the shared preferences)
  bool _isFavorite = false;
  bool _isWatched = false;

  // String containing the movie video url (will be fetched from the API)
  String _videoUrl = "";

  // Youtube utils
  late YoutubePlayerController _youtubePlayerController;

  // Constructor
  MovieDetailState(this.movieID);

  // The movie to display in the page (will be fetched from the API)
  // Placeholder movie by default
  Movie movie = Movie(
    id: -1,
    backdrop_path: null,
    homepage: null,
    original_title: "Loading movie ...",
    overview: "Loading the movie description ...",
    poster_path: null,
    release_date: "Coming soon ...",
    vote_average: 0,
  );

  // List of the casting to display in the page (will be fetched from the API)
  List<Cast> cast = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Initialize the page
  void _init() async {
    // Init shared preferences
    await _initSharedPreferences();

    // Fetch the movie, the cast and the url of the movie video
    await _initMovie();
    await _initCast();
    await _getMovieVideoUrl();

    // Youtube utils
    final videoID = YoutubePlayer.convertUrlToId(_videoUrl);
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoID ?? "",
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    // Fetch the list of all favorite / watched movies id (from the shared preferences) if null, set it to an empty list by default
    _favoriteMovies = _prefs.getStringList("favorite_movies") ?? [];
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    // Determine if the movie is in the favorite list (from the shared preferences)
    _isFavorite = _favoriteMovies.contains(movieID.toString());

    // Determine if the movie is in the watched list (from the shared preferences)
    _isWatched = _watchedMovies.contains(movieID.toString());
  }

  // Init shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Fetch the movie ...
  Future<void> _initMovie() async {
    Movie movieFetched = await Movie.fetchMovieById(movieID);
    setState(() => movie = movieFetched);
  }

  // ... and the cast
  Future<void> _initCast() async {
    APICastResponse apiCastResponse =
        await APICastResponse.fetchCastByMovieId(movieID);
    List<Cast> castFetched = apiCastResponse.cast;
    setState(() => cast = castFetched);
  }

  /// ********************************************************************* ///
  /// ***************************** Callbacks ***************************** ///
  /// ********************************************************************* ///

  // Callbacks for the CTAs
  void _handleFavoriteButtonPressed() async {
    // If the movie is already in the favorite list, remove it, else add it
    if (_isFavorite) {
      _favoriteMovies.remove(movieID.toString());
    } else {
      _favoriteMovies.add(movieID.toString());
    }

    // Update the UI state dynamically
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Save the list of all favorite movies id (in the shared preferences)
    _prefs.setStringList("favorite_movies", _favoriteMovies);
  }

  void _handleWatchedButtonPressed() async {
    // If the movie is already in the watched list, remove it, else add it
    if (_isWatched) {
      _watchedMovies.remove(movieID.toString());
    } else {
      _watchedMovies.add(movieID.toString());
    }

    // Update the UI state dynamically
    setState(() {
      _isWatched = !_isWatched;
    });

    // Save the list of all watched movies id (in the shared preferences)
    _prefs.setStringList("watched_movies", _watchedMovies);
  }

  /// ****************************************************************************** ///
  /// ***************************** Youtube management ***************************** ///
  /// ****************************************************************************** ///

  // Get the movie video url (if it exists)
  Future<void> _getMovieVideoUrl() async {
    APIVideoResponse apiVideoResponse =
        await APIVideoResponse.fetchFirstVideoFromMovieID(movieID);
    List<Video> videos = apiVideoResponse.results;
    List<Video> filteredVideos = videos
        .where((video) =>
            video.size == 1080 &&
            video.site == "YouTube" &&
            video.type == "Trailer" &&
            video.official == true)
        .toList();

    // Return the first video url if it exists, else return an empty string
    setState(() {
      _videoUrl = filteredVideos.isNotEmpty
          ? "https://www.youtube.com/watch?v=${filteredVideos[0].key}"
          : "";
    });
  }

  // Launch movie trailer (when it's available)
  Future<void> _launchUrl(String url) async {
    Uri trailerUrl = Uri.parse(url);
    if (!await launchUrl(trailerUrl)) {
      throw Exception('Could not launch $trailerUrl');
    }
  }

  /// ********************************************************************** ///
  /// ***************************** Build page ***************************** ///
  /// ********************************************************************** ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BaseStyles.primaryColor,
          title: Text(movie.original_title, style: BaseStyles.boldText),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _init(),
          child: SingleChildScrollView(
            child: _renderPage(),
          ),
        ));
  }

  Widget _renderPage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: BaseStyles.spacing_3),
      child: Column(
        children: [
          _renderMovieIllustration(),
          _renderMovieHeader(),
          _renderCTAs(),
          _renderMovieSynopsis(),
          _renderCasting(),
        ],
      ),
    );
  }

  /// ******************************************************************************************************* ///
  /// ***************************** Render movie illustration (video or poster) ***************************** ///
  /// ******************************************************************************************************* ///

  Widget _renderMovieIllustration() {
    // If there is a video url, display a video player, else display a poster image
    if (_videoUrl.isNotEmpty) {
      return _renderMovieVideo();
    } else {
      return _renderMoviePoster();
    }
  }

  Widget _renderMovieVideo() {
    return YoutubePlayer(
      controller: _youtubePlayerController,
      showVideoProgressIndicator: true,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              playedColor: BaseStyles.lightBlue,
              handleColor: BaseStyles.lightBlue,
              bufferedColor: BaseStyles.lightBlue.withOpacity(0.5),
            )),
        RemainingDuration(),
        FullScreenButton(),
      ],
    );
  }

  Widget _renderMoviePoster() {
    // If there is no poster image, display a placeholder image
    ImageProvider image = AssetImage(Utils.noMoviePosterURI);

    if (movie.poster_path != null) {
      image = NetworkImage(
        Utils.apiImageURL + movie.poster_path!,
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }

  /// ************************************************************************************************************** ///
  /// ***************************** Render movie header (basic and fav / watched info) ***************************** ///
  /// ************************************************************************************************************** ///

  Widget _renderMovieHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: BaseStyles.spacing_3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderMovieHeaderBasicInfo(),
          _renderMovieHeaderActionsInfo(),
        ],
      ),
    );
  }

  Widget _renderMovieHeaderBasicInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _returnMovieHeaderYearAndTitle(),
        // Add a space between the year and the title and the rating
        const SizedBox(width: BaseStyles.spacing_5),
        _renderMovieHeaderRating(),
      ],
    );
  }

  Widget _returnMovieHeaderYearAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderMovieHeaderYear(),
        _renderMovieHeaderTitle(),
      ],
    );
  }

  Widget _renderMovieHeaderYear() {
    // Check if the movie has a release date (if not, display 'To be announced')
    String movieReleaseDate = movie.release_date != ""
        ? movie.release_date!.substring(0, 4)
        : "To be announced";
    return Text(
      movieReleaseDate,
      style: BaseStyles.smallText,
    );
  }

  Widget _renderMovieHeaderTitle() {
    return SizedBox(
      width: 250.0,
      child: Text(
        movie.original_title,
        style: BaseStyles.h2,
      ),
    );
  }

  Widget _renderMovieHeaderRating() {
    int rating = (movie.vote_average * 10).toInt();
    return Row(
      children: [
        Icon(
          FeatherIcons.star,
          color: BaseStyles.yellowStar,
          size: MovieStyles.movieDefaultIconSize,
        ),
        // Add a space between the icon and the text
        const SizedBox(width: BaseStyles.spacing_1),
        Text(
          "$rating %",
          style: BaseStyles.boldSmallYellowText,
        ),
      ],
    );
  }

  Widget _renderMovieHeaderActionsInfo() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _renderIsMovieFavorite(),
          // Add a space between the favorite button and the watched button
          const SizedBox(width: BaseStyles.spacing_3),
          _renderIsMovieWatched(),
        ],
      ),
    );
  }

  Widget _renderIsMovieFavorite() {
    // Check if the movie is favorite or not to display the right icon
    IconData icon = _isFavorite ? FeatherIcons.xCircle : FeatherIcons.heart;

    return TextButton(
      onPressed: () => _handleFavoriteButtonPressed(),
      child: Row(
        children: [
          Icon(
            icon,
            color: BaseStyles.candy,
            size: MovieStyles.movieDefaultIconSize,
          ),
          // Add a space between the icon and the text
          const SizedBox(width: BaseStyles.spacing_1),
          Text(
            // Check if the movie is favorite or not to display the right text
            _isFavorite
                ? "Remove from your favorites"
                : "Add to your favorites",
            style: BaseStyles.boldSmallCandyText,
          ),
        ],
      ),
    );
  }

  Widget _renderIsMovieWatched() {
    // Check if the movie is watched or not to display the right icon
    IconData icon = _isWatched ? FeatherIcons.checkCircle : FeatherIcons.eyeOff;

    return TextButton(
      onPressed: () => _handleWatchedButtonPressed(),
      child: Row(
        children: [
          Icon(
            icon,
            color: BaseStyles.lightBlue,
            size: MovieStyles.movieDefaultIconSize,
          ),
          // Add a space between the icon and the text
          const SizedBox(width: BaseStyles.spacing_1),
          Text(
            // Check if the movie is watched or not to display the right text
            _isWatched ? "Mark as unwatched" : "Mark as watched",
            style: BaseStyles.boldSmallText,
          ),
        ],
      ),
    );
  }

  /// ************************************************************************************ ///
  /// ***************************** Render movie header CTAs ***************************** ///
  /// ************************************************************************************ ///

  Widget _renderCTAs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildCTASection(),
    );
  }

  List<Widget> _buildCTASection() {
    List<Widget> ctas = [];

    // If there is no videos available, we don't display the button
    if (_videoUrl != "") {
      ctas.add(_buildWatchTrailerCTA());
      // Add a space between the youtube trailer button and the share button
      ctas.add(const SizedBox(width: BaseStyles.spacing_3));
    }

    ctas.add(_buildShareCTA());
    return ctas;
  }

  Widget _buildWatchTrailerCTA() {
    return TextButton(
        onPressed: () => _launchUrl(_videoUrl),
        style: BaseStyles.ctaButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: BaseStyles.spacing_1, horizontal: BaseStyles.spacing_2),
          child: Row(
            children: [
              Text(
                "Watch the trailer on Youtube",
                style: BaseStyles.boldSmallText,
              ),
              // Add a space between the icon and the text
              const SizedBox(width: BaseStyles.spacing_1),
              Icon(
                FeatherIcons.externalLink,
                color: BaseStyles.lightBlue,
                size: MovieStyles.movieCTAIconSize,
              ),
            ],
          ),
        ));
  }

  Widget _buildShareCTA() {
    return TextButton(
        onPressed: () => Share.share(
            "Check out this movie: ${movie.original_title}, it seems to be a good one! $_videoUrl"),
        style: BaseStyles.ctaButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: BaseStyles.spacing_1, horizontal: BaseStyles.spacing_2),
          child: Row(
            children: [
              Text(
                "Share",
                style: BaseStyles.boldSmallText,
              ),
              // Add a space between the icon and the text
              const SizedBox(width: BaseStyles.spacing_1),
              Icon(
                FeatherIcons.share2,
                color: BaseStyles.lightBlue,
                size: MovieStyles.movieCTAIconSize,
              ),
            ],
          ),
        ));
  }

  /// ********************************************************************************* ///
  /// ***************************** Render movie synopsis ***************************** ///
  /// ********************************************************************************* ///

  Widget _renderMovieSynopsis() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_3),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_3),
        child: Text(
          movie.overview,
          style: BaseStyles.text,
        ),
      ),
    );
  }

  /// ******************************************************************************** ///
  /// ***************************** Render movie casting ***************************** ///
  /// ******************************************************************************** ///

  Widget _renderCasting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderCastingTitle(),
        _renderCastingCharacters(),
      ],
    );
  }

  // Render the Trendy section title
  Widget _renderCastingTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_4, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: Text(
        "Casting",
        style: BaseStyles.h2,
      ),
    );
  }

  // Render the casting characters
  Widget _renderCastingCharacters() {
    // If there is a casting, we display it
    if (cast.isNotEmpty) {
      return SizedBox(
        height: MovieStyles.actorCardSize,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(BaseStyles.spacing_2,
              BaseStyles.spacing_2, BaseStyles.spacing_2, BaseStyles.spacing_0),
          itemCount: cast.length,
          itemBuilder: _actorCardBuilder,
        ),
      );
    }

    // If there is no casting, we display a message
    else {
      return Text(
        "No casting available",
        style: BaseStyles.text,
      );
    }
  }

  Widget _actorCardBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_0),
      child: Column(
        children: [
          SimpleCardBuilder.renderSimpleCardImage(cast[index].profile_path),
          SimpleCardBuilder.renderSimpleCardTitle(cast[index].name),
          SimpleCardBuilder.renderSimpleCardSubtitle(cast[index].character),
        ],
      ),
    );
  }
}
