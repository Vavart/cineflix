// Basic import
import 'package:flutter/material.dart';

// Style utils
import 'package:cineflix/styles/utils.dart';

class BaseStyles {
  // Typography
  static const String fontFamily = 'Comfortaa';

  // Sizes
  static const h1Size = 32.0;
  static const h2Size = 20.0;
  static const textSize = 15.0;
  static const smallTextSize = 10.0;
  static const iconSize = 30.0;

  // Spacing
  static const double spacing_0 = 0.0;
  static const double spacing_1 = 5.0;
  static const double spacing_2 = 10.0;
  static const double spacing_3 = 20.0;
  static const double spacing_4 = 30.0;
  static const double spacing_5 = 40.0;
  static const double spacing_6 = 50.0;
  static const double spacing_7 = 60.0;
  static const double spacing_8 = 100.0;
  static const double spacing_9 = 150.0;
  static const double spacing_10 = 200.0;

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
  static TextStyle appTitle = TextStyle(
      fontFamily: fontFamily,
      fontSize: h1Size,
      color: lightBlue,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle h1 = TextStyle(
      fontFamily: fontFamily,
      fontSize: h1Size,
      color: white,
      fontWeight: FontWeight.w300,
      height: 1.6);

  static TextStyle h2 = TextStyle(
      fontFamily: fontFamily,
      fontSize: h2Size,
      color: white,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle text = TextStyle(
      fontFamily: fontFamily,
      fontSize: textSize,
      color: white,
      fontWeight: FontWeight.w300,
      height: 1.6);

  static TextStyle smallText = TextStyle(
      fontFamily: fontFamily,
      fontSize: smallTextSize,
      color: white,
      fontWeight: FontWeight.w300,
      height: 1.6);

  static TextStyle boldText = TextStyle(
      fontFamily: fontFamily,
      fontSize: textSize,
      color: white,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle boldSmallText = TextStyle(
      fontFamily: fontFamily,
      fontSize: smallTextSize,
      color: white,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle boldSmallYellowText = TextStyle(
      fontFamily: fontFamily,
      fontSize: smallTextSize,
      color: yellowStar,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle boldSmallCandyText = TextStyle(
      fontFamily: fontFamily,
      fontSize: smallTextSize,
      color: candy,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle placeholder = TextStyle(
      fontFamily: fontFamily,
      fontSize: textSize,
      color: darkShade_2,
      fontWeight: FontWeight.w300,
      height: 1.6);

  static TextStyle snackBarText = TextStyle(
      fontFamily: fontFamily,
      fontSize: smallTextSize,
      color: white,
      fontWeight: FontWeight.w700,
      height: 1.6);

  // Buttons Styles
  static final ctaButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(BaseStyles.darkShade_1),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_10),
      ),
    ),
  );
}
