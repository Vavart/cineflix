// Basic imports
import 'package:flutter/material.dart';
import 'package:cineflix/pages/movie_detail.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/search.dart';
import 'package:cineflix/styles/movies.dart';

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
    return SingleChildScrollView(child: Column(children: [_renderPage()]));
  }

  Widget _renderPage() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_6),
      child: Column(
        children: <Widget>[
          _renderFullSearchBar(),
          _renderTrendySection(),
          _renderSelectedMovies()
        ],
      ),
    );
  }

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

  // Render the Trendy section
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
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(BaseStyles.spacing_2),
        itemCount: 6,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: BaseStyles.spacing_2),
        itemBuilder: _simpleMovieCardBuilder,
      ),
    );
  }

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
        width: MovieStyles.simpleMovieImgWidth,
        height: MovieStyles.simpleMovieImgHeight,
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

  Widget _renderSelectedMovies() {
    return Column(
      children: const [Text("Our selection")],
    );
  }

  // Navigation methods

  void _navigationToMovieDetail(BuildContext context, int index) {
    print("Navigation to Movie Detail");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }
}
