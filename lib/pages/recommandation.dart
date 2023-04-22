// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:cineflix/styles/recommandation.dart';
import 'package:feather_icons/feather_icons.dart';

class Recommandation extends StatefulWidget {
  const Recommandation({super.key});

  @override
  RecommandationState createState() => RecommandationState();
}

class RecommandationState extends State<Recommandation> {
  // Current tab index (0: Classic page, 1: Movie suggestion)
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: IndexedStack(
        index: _currentIndex,
        children: [
          _renderClassicPage(),
          _renderMovieSuggestion(),
        ],
      ),
    );
  }

  /// ******************************************************************************************** ///
  /// ***************************** Render movies suggestion widget  ***************************** ///
  /// ******************************************************************************************** ///

  final List<String> _moviesSuggTitles = [
    "The Shawshank Redemption",
    "The Godfather",
    "The Dark Knight",
  ];

  final List<String> _moviesSuggPosters = [
    "https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
    "https://image.tmdb.org/t/p/w500/rPdtLWNsZmAtoZl9PK7S2wE3qiS.jpg",
    "https://image.tmdb.org/t/p/w500/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg",
  ];

  Widget _renderMovieSuggestion() {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_9, bottom: BaseStyles.spacing_6),
      child: Column(
        children: [
          _renderMovieSuggHeader(),
          _renderSuggestions(),
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

    // _moviesSuggTitles.length = _moviesSuggPosters.length
    for (int i = 0; i < _moviesSuggTitles.length; i++) {
      suggestionCards.add(
          _renderSuggestionCard(_moviesSuggTitles[i], _moviesSuggPosters[i]));
    }
    return suggestionCards;
  }

  Widget _renderSuggestionCard(String title, String poster) {
    return GestureDetector(
      // ignore: avoid_print
      onTap: () => print("Movie suggestion card tapped"),
      child: Column(
        children: [
          _renderSuggestionCardImage(poster),
          _renderSuggestionCardTitle(title),
        ],
      ),
    );
  }

  Widget _renderSuggestionCardImage(String poster) {
    return Container(
      width: MovieStyles.movieCardImgWidth,
      height: MovieStyles.movieCardImgHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        image: DecorationImage(
          image: NetworkImage(poster),
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
        "Our AI is based on your favorites movies , and don’t worry, it will not be something you’ve already watched !",
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
}
