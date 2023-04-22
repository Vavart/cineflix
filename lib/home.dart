// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

// Widgets imports
import 'package:cineflix/components/bottom_navigation_bar.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State {

  // Current tab index
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: IndexedStack(
        index: _currentIndex,
        children: CineflixBottomNavgationBar.pages,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,

      items: CineflixBottomNavgationBar.navItems,
      currentIndex: _currentIndex,

      selectedItemColor: BaseStyles.primaryColor,
      unselectedItemColor: BaseStyles.darkShade_2,
      backgroundColor: BaseStyles.white,
      selectedFontSize: BaseStyles.textSize,

      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },

    );
  }

}
