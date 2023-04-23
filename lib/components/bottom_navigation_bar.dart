// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:feather_icons/feather_icons.dart';
import 'package:cineflix/styles/base.dart';

// Pages imports
import 'package:cineflix/pages/movies.dart';
import 'package:cineflix/pages/recommandation.dart';
import 'package:cineflix/pages/favorites.dart';
import 'package:cineflix/pages/profile.dart';


class CineflixBottomNavgationBar {
    // Bottom navigation bar items list
  static final List<BottomNavigationBarItem> navItems = [
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.all(BaseStyles.spacing_1),
        child: Icon(FeatherIcons.film),
      ),
      label: "Movies",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.all(BaseStyles.spacing_1),
        child: Icon(FeatherIcons.cpu),
      ),
      label: "AI",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.all(BaseStyles.spacing_1),
        child: Icon(FeatherIcons.heart),
      ),
      label: "Favorites",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.all(BaseStyles.spacing_1),
        child: Icon(FeatherIcons.user),
      ),
      label: "Profile",
    ),
  ];

  // Application pages list (to be displayed in the IndexedStack)
  static final List<Widget> pages = [
    const Movies(),
    const Recommandation(),
    const Favorites(),
    const Profile(),
  ];
}