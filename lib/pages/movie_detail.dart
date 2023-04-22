// Basic imports
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

class MovieDetail extends StatefulWidget {
  final int movieID;
  const MovieDetail({super.key, required this.movieID});

  @override
  // ignore: no_logic_in_create_state
  createState() => _MovieDetail(movieID: movieID);
}

class _MovieDetail extends State<MovieDetail> {
  final int movieID;
  _MovieDetail({required this.movieID});

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BaseStyles.primaryColor,
          title: Text("John Wick : Chapter 4", style: BaseStyles.boldText),
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
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // Replace later with NetworkImage when we have the API
          image: AssetImage("assets/images/movie_illustration.png"),
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
      "2023",
      style: BaseStyles.smallText,
    );
  }

  Widget _renderMovieHeaderTitle() {
    return Text(
      "John Wick : Chapter 4",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: BaseStyles.h2,
    );
  }

  Widget _renderMovieHeaderRating() {
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
          "90%",
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
          "John Wick faces his most formidable adversaries in this fourth installment of the series. From New York to Osaka, via Paris and Berlin, John Wick leads a fight against the Big Table, the terrible criminal organization that has put a price on his head, by facing its most dangerous killers...",
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
        itemCount: 6,
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
          _renderActorCardPicture(),
          _renderActorCardName(),
          _renderActorCardRole(),
        ],
      ),
    );
  }

  Widget _renderActorCardPicture() {
    return Container(
      width: MovieStyles.actorCardImgWidth,
      height: MovieStyles.actorCardImgHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        image: const DecorationImage(
          image: AssetImage("assets/images/keanu_reeves.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _renderActorCardName() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_1),
      width: 100,
      child: Text(
        "Keanu Reeves",
        style: BaseStyles.boldSmallText,
        textAlign: TextAlign.center,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _renderActorCardRole() {
    return Text(
      "John Wick",
      style: BaseStyles.smallText,
      textAlign: TextAlign.center,

      // Limit the number of lines to 2 and add an ellipsis if the text is too long
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
