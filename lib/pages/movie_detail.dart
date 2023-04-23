// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models import
import 'package:cineflix/models/movie.dart';
import 'package:cineflix/models/api_cast_response.dart';
import 'package:cineflix/models/cast.dart';

class MovieDetail extends StatefulWidget {
  // Movie ID
  final int movieID;
  const MovieDetail({super.key, required this.movieID});

  @override
  // ignore: no_logic_in_create_state
  createState() => MovieDetailState(movieID);
}

class MovieDetailState extends State<MovieDetail> {
  int movieID;
  MovieDetailState(this.movieID);

  // List of actions for the CTAs
  final List<String> _ctaActions = [
    "Mark as unwatched",
    "Watch trailer",
    "Share",
  ];

  // List of icons for the CTAs
  final List<Icon> _ctaIcons = [
    Icon(
      FeatherIcons.eyeOff,
      color: BaseStyles.lightBlue,
      size: MovieStyles.movieCTAIconSize,
    ),
    Icon(
      FeatherIcons.externalLink,
      color: BaseStyles.lightBlue,
      size: MovieStyles.movieCTAIconSize,
    ),
    Icon(
      FeatherIcons.share2,
      color: BaseStyles.lightBlue,
      size: MovieStyles.movieCTAIconSize,
    ),
  ];

  // The movie to display in the page (will be fetched from the API)
  Movie movie = Movie(
    id: -1,
    backdrop_path: null,
    homepage: null,
    original_title: "Placeholder movie",
    overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
    poster_path: null,
    release_date: "1970-01-01",
    vote_average: 0,
  );

  // List of cast to display in the page (will be fetched from the API)
  List<Cast> cast = [];

  // API url to get images
  final String _apiImageUrl = "https://image.tmdb.org/t/p/original";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    // Fetch the movie and the cast
    await _initMovie();
    await _initCast();
  }

  Future<void> _initMovie() async {
    Movie movieFetched = await Movie.fetchMovieById(movieID);
    setState(() => movie = movieFetched);
  }

  Future<void> _initCast() async {
    APICastResponse apiCastResponse =
        await APICastResponse.fetchCastByMovieId(movieID);
    List<Cast> castFetched = apiCastResponse.cast;
    setState(() => cast = castFetched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BaseStyles.primaryColor,
          title: Text(movie.original_title, style: BaseStyles.boldText),
        ),
        body: SingleChildScrollView(
          child: _renderPage(),
        ));
  }

  Widget _renderPage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: BaseStyles.spacing_0),
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

  Widget _renderMovieIllustration() {
    ImageProvider image;
    if (movie.poster_path != null) {
      image = NetworkImage(
        _apiImageUrl + movie.poster_path!,
      );
    } else {
      image = const AssetImage(
        "assets/images/no_movie_illustration_preview.png",
      );
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

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
    return Text(
      movie.release_date.substring(0, 4),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _renderIsMovieFavorite(),
        // Add a space between the favorite button and the watched button
        const SizedBox(width: BaseStyles.spacing_3),
        _renderIsMovieWatched(),
      ],
    );
  }

  Widget _renderIsMovieFavorite() {
    return TextButton(
      // ignore: avoid_print
      onPressed: () => print("Favorite button pressed"),
      child: Row(
        children: [
          Icon(
            FeatherIcons.heart,
            color: BaseStyles.candy,
            size: MovieStyles.movieDefaultIconSize,
          ),
          // Add a space between the icon and the text
          const SizedBox(width: BaseStyles.spacing_1),
          Text(
            "Add to your favorites",
            style: BaseStyles.boldSmallCandyText,
          ),
        ],
      ),
    );
  }

  Widget _renderIsMovieWatched() {
    return Row(
      children: [
        Icon(
          FeatherIcons.eye,
          color: BaseStyles.lightBlue,
          size: MovieStyles.movieDefaultIconSize,
        ),
        // Add a space between the icon and the text
        const SizedBox(width: BaseStyles.spacing_1),
        Text(
          "Watched",
          style: BaseStyles.boldSmallText,
        ),
      ],
    );
  }

  Widget _renderCTAs() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildCTASection(),
      ),
    );
  }

  List<Widget> _buildCTASection() {
    List<Widget> ctas = [];

    for (var i = 0; i < _ctaActions.length; i++) {
      ctas.add(_ctaBuilder(_ctaActions[i], _ctaIcons[i]));
      if (i != _ctaActions.length - 1) {
        ctas.add(const SizedBox(width: BaseStyles.spacing_1));
      }
    }
    return ctas;
  }

  Widget _ctaBuilder(String action, Icon icon) {
    return TextButton(
        // ignore: avoid_print
        onPressed: () => print("Tapped"),
        style: BaseStyles.ctaButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: BaseStyles.spacing_1, horizontal: BaseStyles.spacing_2),
          child: Row(
            children: [
              Text(
                action,
                style: BaseStyles.boldSmallText,
              ),
              // Add a space between the icon and the text
              const SizedBox(width: BaseStyles.spacing_1),
              icon,
            ],
          ),
        ));
  }

  Widget _renderMovieSynopsis() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_4),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_3),
        child: Text(
          movie.overview,
          style: BaseStyles.text,
        ),
      ),
    );
  }

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

  // Render the Trendy section movies
  Widget _renderCastingCharacters() {
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

  // Render a simple movie card : image + title
  Widget _actorCardBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_0),
      child: Column(
        children: [
          _renderActorCardPicture(index),
          _renderActorCardName(index),
          _renderActorCardRole(index),
        ],
      ),
    );
  }

  Widget _renderActorCardPicture(int index) {
    ImageProvider image;
    if (cast[index].profile_path != null) {
      image = NetworkImage(
        _apiImageUrl + cast[index].profile_path!,
      );
    } else {
      image = const AssetImage(
        "assets/images/no_movie_preview.png",
      );
    }

    return Container(
      width: MovieStyles.actorCardImgWidth,
      height: MovieStyles.actorCardImgHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _renderActorCardName(int index) {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_1),
      width: 100,
      child: Text(
        cast[index].name,
        style: BaseStyles.boldSmallText,
        textAlign: TextAlign.center,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _renderActorCardRole(int index) {
    return Text(
      cast[index].character,
      style: BaseStyles.smallText,
      textAlign: TextAlign.center,

      // Limit the number of lines to 2 and add an ellipsis if the text is too long
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
