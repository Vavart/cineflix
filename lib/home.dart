// Basic imports
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/menu.dart';

// Pages imports
import 'package:cineflix/pages/movies.dart';
import 'package:cineflix/pages/recommandation.dart';
import 'package:cineflix/pages/favorites.dart';
import 'package:cineflix/pages/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State {
  // Current tab index
  int _currentIndex = 0;

  // Application pages list (to be displayed in the IndexedStack)
  static final List<Widget> _pages = [
    const Movies(),
    const Recommandation(),
    const Favorites(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildNewBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "search",
      onPressed: () {
        setState(() {
          _currentIndex = 0;
        });
      },
      backgroundColor: BaseStyles.darkBlue,
      child: Icon(
        FeatherIcons.search,
        color: BaseStyles.white,
      ),
    );
  }

  Widget _buildNewBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: BaseStyles.spacing_1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_1),
        child: SizedBox(
          height: MenuStyles.bottomAppBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _renderFirstBottomNavigationItem(),
              _renderSecondBottomNavigationItem(),
              const SizedBox(width: BaseStyles.spacing_4),
              _renderThirdBottomNavigationItem(),
              _renderFourthBottomNavigationItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderFirstBottomNavigationItem() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 0),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_1),
        child: Column(
          children: [
            Icon(
              FeatherIcons.film,
              size: MenuStyles.iconSize,
              color: _currentIndex == 0
                  ? MenuStyles.selectedColor
                  : MenuStyles.unSelectedColor,
            ),
            Text(
              "Movies",
              style: _currentIndex == 0
                  ? MenuStyles.selectedText
                  : MenuStyles.unSelectedText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderSecondBottomNavigationItem() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 1),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_1),
        child: Column(
          children: [
            Icon(
              FeatherIcons.compass,
              size: MenuStyles.iconSize,
              color: _currentIndex == 1
                  ? MenuStyles.selectedColor
                  : MenuStyles.unSelectedColor,
            ),
            Text(
              "Discover",
              style: _currentIndex == 1
                  ? MenuStyles.selectedText
                  : MenuStyles.unSelectedText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderThirdBottomNavigationItem() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 2),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_1),
        child: Column(
          children: [
            Icon(
              FeatherIcons.heart,
              size: MenuStyles.iconSize,
              color: _currentIndex == 2
                  ? MenuStyles.selectedColor
                  : MenuStyles.unSelectedColor,
            ),
            Text(
              "Favorites",
              style: _currentIndex == 2
                  ? MenuStyles.selectedText
                  : MenuStyles.unSelectedText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderFourthBottomNavigationItem() {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = 3),
      child: Padding(
        padding: const EdgeInsets.all(BaseStyles.spacing_1),
        child: Column(
          children: [
            Icon(
              FeatherIcons.user,
              size: MenuStyles.iconSize,
              color: _currentIndex == 3
                  ? MenuStyles.selectedColor
                  : MenuStyles.unSelectedColor,
            ),
            Text(
              "Profile",
              style: _currentIndex == 3
                  ? MenuStyles.selectedText
                  : MenuStyles.unSelectedText,
            ),
          ],
        ),
      ),
    );
  }
}
