// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/search.dart';

class Movies extends StatelessWidget {
  Movies({super.key});

  // Search bar text field controller (to clear the field)
  final searchBarField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _renderPage()),
    );
  }

  Widget _renderPage() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_6),
      child: Column(
        children: <Widget>[
          _renderFullSearchBar(),
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

  void clearSearchBar() {
    searchBarField.clear();
  }

  Widget _renderSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_3),
      child: Row(children: [
        Flexible(
          child: TextField(
              controller: searchBarField,
              cursorColor: BaseStyles.white,
              style: BaseStyles.text,
              onSubmitted: (value) => print(value),
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
}
