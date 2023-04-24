// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'base.dart';

class MenuStyles {

  static const double iconSize = 24;
  static const double bottomAppBarHeight = 55;

  static Color selectedColor = BaseStyles.primaryColor;
  static Color unSelectedColor = BaseStyles.darkShade_2;

  static TextStyle selectedText = TextStyle(
      fontFamily: BaseStyles.fontFamily,
      fontSize: BaseStyles.smallTextSize,
      color: selectedColor,
      fontWeight: FontWeight.w700,
      height: 1.6);

  static TextStyle unSelectedText = TextStyle(
      fontFamily: BaseStyles.fontFamily,
      fontSize: BaseStyles.smallTextSize,
      color: unSelectedColor,
      fontWeight: FontWeight.w700,
      height: 1.6);

}