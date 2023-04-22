// Basic imports
import 'package:flutter/material.dart';
import 'movie_detail.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _renderPage(context),
      ),
    );
  }

  Widget _renderPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_6, bottom: BaseStyles.spacing_6),
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
        // Render the 5 selected movies (for loop because ListView.builder doesn't work with Column (unbounded height issues))
        for (int i = 0; i < 5; i++)
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
      onTap: () => _navigationToMovieDetail(context, index),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderMovieComplexCardImage(),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_2),
            _renderMovieComplexCardInfo(context),
            // Separator between the info and the trash icon
            const SizedBox(width: BaseStyles.spacing_2),
            _renderMovieComplexCardTrashIcon(),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieComplexCardImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
      child: Image.asset(
        "assets/images/no_movie_preview.png",
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderMovieComplexCardInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderMovieComplexCardTitle(),
        _renderMovieComplexCardIcons(),
        _renderMovieComplexCardDescription(context),
      ],
    );
  }

  Widget _renderMovieComplexCardTitle() {
    return Text(
      textAlign: TextAlign.left,
      "Movie Title",
      style: BaseStyles.boldText,
    );
  }

  Widget _renderMovieComplexCardIcons() {
    return Row(
      children: [
        _renderMovieComplexCardRating(),
        _renderMovieComplexCardWatchIcon(),
      ],
    );
  }

  Widget _renderMovieComplexCardRating() {
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
            "90%",
            style: BaseStyles.boldSmallYellowText,
          ),
        ],
      ),
    );
  }

  Widget _renderMovieComplexCardWatchIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Icon(
        FeatherIcons.eye,
        color: BaseStyles.lightBlue,
      ),
    );
  }

  Widget _renderMovieComplexCardDescription(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 150.0
          : MediaQuery.of(context).size.width * 0.6,
      child: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget aliquam ultricies, nisl nisl ultricies.",
        style: BaseStyles.smallText,
        textAlign: TextAlign.left,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _renderMovieComplexCardTrashIcon() {
    return TextButton(
      // ignore: avoid_print
      onPressed: () => print("Trash icon pressed"),
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
