// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

class MovieStyles {
  static const double simpleMovieCardHeight = 250;
  static const double complexMovieCardHeight = 150;

  static const double movieCardImgWidth = 100;
  static const double movieCardImgHeight = 150;

  static const double movieDefaultIconSize = 20;
  static const double movieCTAIconSize = 15;

  static const double actorCardSize = 275;
  static const double actorCardImgWidth = 120;
  static const double actorCardImgHeight = 150;

  static final ctaButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(BaseStyles.darkShade_1),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_10),
      ),
    ),
  );
}
