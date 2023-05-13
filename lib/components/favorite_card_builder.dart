// Basic import
import 'package:flutter/material.dart';

// Style import
import 'package:cineflix/styles/base.dart';

class FavoriteCardBuilder {
  // Texts
  static String noFavoritesText =
      "You didn't add any movie to your favorites 😢\n\nTry to search for a movie you love !";

  static String noWatchedText =
      "You didn't add any movie to your watched list 😢\n\nTry to search for a movie !";

  // Render methods
  static Widget renderNoFavoritesOrWatchedText(bool isTextFavorite) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_10),
      child: Row(
        children: [
          // Flexible to make the text wrap if the search query is too long
          Flexible(
            child: Text(
              isTextFavorite ? noFavoritesText : noWatchedText,
              style: BaseStyles.text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
