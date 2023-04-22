// Basic imports
import 'package:flutter/material.dart';
import 'package:cineflix/pages/movie_detail.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/search.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

class Movies extends StatelessWidget {
  Movies({super.key});

  // Search bar text field controller (to clear the field)
  final searchBarField = TextEditingController();

  // Associated method to clear the search bar text field
  void clearSearchBar() {
    searchBarField.clear();
  }

  @override
  Widget build(BuildContext context) {
    // return _renderPage(context);
    return SingleChildScrollView(child: _renderPage(context));
  }

  Widget _renderPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_6, bottom: BaseStyles.spacing_6),
      child: Column(
        children: [
          _renderFullSearchBar(),
          _renderTrendySection(),
          _renderSelectedSection(context),
        ],
      ),
    );
  }

  /// ********************************************************************************* ///
  /// ***************************** Render the search bar ***************************** ///
  /// ********************************************************************************* ///

  // Render methods
  Widget _renderFullSearchBar() {
    return Column(
      children: [
        _renderTextSearchBar(),
        _renderSearchBar(),
      ],
    );
  }

  Widget _renderTextSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "What are we watching today ?",
          style: BaseStyles.text,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _renderSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_3),
      child: Row(children: [
        Flexible(
          child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: searchBarField,
              cursorColor: BaseStyles.white,
              style: BaseStyles.text,
              // onSubmitted: (value) => print(value),
              decoration: SearchStyles.searchBar),
        ),

        // Delete the search bar text field content
        TextButton(
          onPressed: clearSearchBar,
          child: Text(
            "Delete",
            style: BaseStyles.text,
          ),
        )
      ]),
    );
  }

  /// ********************************************************************************* ///
  /// *************************** Render the trendy section *************************** ///
  /// ********************************************************************************* ///
  Widget _renderTrendySection() {
    return Column(
      children: [
        _renderTrendySectionTitle(), // Trendy
        _renderTrendyMovies(), // Trendy movies
      ],
    );
  }

  // Render the Trendy section title
  Widget _renderTrendySectionTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_4, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Trendy",
          style: BaseStyles.h2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  // Render the Trendy section movies
  Widget _renderTrendyMovies() {
    return SizedBox(
      height: MovieStyles.simpleMovieCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(BaseStyles.spacing_2),
        itemCount: 6,
        itemBuilder: _simpleMovieCardBuilder,
      ),
    );
  }

  // Render a simple movie card : image + title
  Widget _simpleMovieCardBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: GestureDetector(
        onTap: () => _navigationToMovieDetail(context, index),
        child: Column(
          children: [
            _renderMovieSimpleCardImage(),
            _renderMovieSimpleCardTitle(),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieSimpleCardImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
      child: Image.asset(
        "assets/images/movie_poster.png",
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _renderMovieSimpleCardTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: 100,
      child: Text(
        "John Wick : Chapter 4",
        style: BaseStyles.boldSmallText,
        textAlign: TextAlign.center,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// ******************************************************************************************* ///
  /// ***************************  Render the selected movies section *************************** ///
  /// ******************************************************************************************* ///

  // Render the selected movies section
  Widget _renderSelectedSection(BuildContext context) {
    return Column(
      children: [
        _renderSelectedMoviesTitle(), // Selected movies
        _renderSelectedMoviesList(context), // Selected movies list
      ],
    );
  }

  // Render the Selected movies section title
  Widget _renderSelectedMoviesTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_4, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Our selection",
          style: BaseStyles.h2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _renderSelectedMoviesList(BuildContext context) {
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
            child: _complexMovieCard(context, i),
          ),
      ],
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexMovieCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigationToMovieDetail(context, index),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderMovieComplexCardImage(),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_3),
            _renderMovieComplexCardInfo(context),
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
          ? 200.0
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

  // Navigation methods
  void _navigationToMovieDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }
}
