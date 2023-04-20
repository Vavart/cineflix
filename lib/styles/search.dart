// Basic imports
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

class SearchStyles {
  // Text field decoration
  static InputDecoration searchBar = InputDecoration(
    // Icon
    prefixIcon: const Icon(FeatherIcons.search),
    prefixIconColor: BaseStyles.white,

    // Placeholder
    hintText: "Search...",
    hintStyle: BaseStyles.placeholder,

    // Content padding
    contentPadding: const EdgeInsets.symmetric(
        vertical: BaseStyles.spacing_3, horizontal: BaseStyles.spacing_3),

    // No border
    border: OutlineInputBorder(
      borderSide: BorderSide(color: BaseStyles.primaryColor, width: 0),
      borderRadius:
          const BorderRadius.all(Radius.circular(BaseStyles.spacing_10)),
    ),

    // No border
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: BaseStyles.primaryColor, width: 0),
      borderRadius:
          const BorderRadius.all(Radius.circular(BaseStyles.spacing_10)),
    ),

    // But focus border
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: BaseStyles.white, width: 2.0),
      borderRadius:
          const BorderRadius.all(Radius.circular(BaseStyles.spacing_10)),
    ),

    // Filled + fillColor
    filled: true,
    fillColor: BaseStyles.darkShade_1,


  );
}


