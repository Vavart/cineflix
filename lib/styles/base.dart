// Basic imports
import 'package:flutter/material.dart';

// Utils
import 'utils.dart';

class BaseStyles {
  // Typography
  static const String _fontFamily = 'Comfortaa';

  // Sizes
  static const h1Size = 32.0;
  static const h2Size = 20.0;
  static const textSize = 15.0;
  static const smallTextSize = 10.0;
  static const iconSize = 30.0;

  // Spacing
  static const double spacing_1 = 6.0;
  static const double spacing_2 = 9.0;
  static const double spacing_3 = 12.0;
  static const double spacing_4 = 16.0;
  static const double spacing_5 = 20.0;

  // Colors (= hex values without #)
  static Color primaryColor = Utils.hexToColor("192C32");
  static Color darkShade_1 = Utils.hexToColor("3D494D");
  static Color darkShade_2 = Utils.hexToColor("667A80");
  static Color darkBlue = Utils.hexToColor("407180");
  static Color lightBlue = Utils.hexToColor("66B4CC");
  static Color white = Utils.hexToColor("F1F1F1");
  static Color yellowStar = Utils.hexToColor("FFB800");
  static Color candy = Utils.hexToColor("FFBCD9");

  // Text Styles
  static TextStyle h1 = TextStyle(
      fontFamily: _fontFamily,
      fontSize: h1Size,
      color: white,
      fontWeight: FontWeight.w300);

  static TextStyle h2 = TextStyle(
      fontFamily: _fontFamily,
      fontSize: h2Size,
      color: white,
      fontWeight: FontWeight.w700);

  static TextStyle text = TextStyle(
      fontFamily: _fontFamily,
      fontSize: textSize,
      color: white,
      fontWeight: FontWeight.w300);

  static TextStyle smallText = TextStyle(
      fontFamily: _fontFamily,
      fontSize: smallTextSize,
      color: white,
      fontWeight: FontWeight.w300);

  static TextStyle boldText = TextStyle(
      fontFamily: _fontFamily,
      fontSize: textSize,
      color: white,
      fontWeight: FontWeight.w700);

  static TextStyle boldSmallText = TextStyle(
      fontFamily: _fontFamily,
      fontSize: smallTextSize,
      color: white,
      fontWeight: FontWeight.w700);
}
