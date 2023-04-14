// Basics imports
import 'package:flutter/material.dart';

// Pages imports
import 'package:cineflix/pages/movies.dart';
import 'package:cineflix/pages/recommandation.dart';
import 'package:cineflix/pages/favorites.dart';
import 'package:cineflix/pages/profile.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:feather_icons/feather_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State {
  // Current tab index
  int currentTab = 0;

  static const List<Widget> _screens = <Widget>[
    Movies(),
    Recommandation(),
    Favorites(),
    Profile(),
  ];

  // Page storage bucket to save and restore the state of the tabs
  final PageStorageBucket bucket = PageStorageBucket();

  // Current screen (home)
  Widget currentScreen = const Movies();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTab,
      selectedItemColor: BaseStyles.primaryColor,
      onTap: (int index) {
        setState(() {
          currentTab = index;
          currentScreen = _screens[index];
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(BaseStyles.spacing_1),
            child: Icon(FeatherIcons.film),
          ),
          label: "Movies",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(BaseStyles.spacing_1),
            child: Icon(FeatherIcons.cpu),
          ),
          label: "AI",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(BaseStyles.spacing_1),
            child: Icon(FeatherIcons.heart),
          ),
          label: "Favorites",
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.all(BaseStyles.spacing_1),
            child: Icon(FeatherIcons.user),
          ),
          label: "Profile",
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: BaseStyles.primaryColor,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: BaseStyles.white),
          borderRadius: BorderRadius.circular(9999)),
      child: const Icon(
        FeatherIcons.search,
        size: BaseStyles.iconSize,
      ),
    );
  }
}
