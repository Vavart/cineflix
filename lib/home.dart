// Basics imports
import 'dart:collection';

import 'package:flutter/material.dart';

// Pages imports
import 'package:cineflix/pages/movies.dart';
import 'package:cineflix/pages/recommandation.dart';
import 'package:cineflix/pages/favorites.dart';
import 'package:cineflix/pages/profile.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State {
  int currentTab = 0;

  // final List<Widget> screens = [
  //   const Movies(),
  //   const Recommandation(),
  //   const Favorites(),
  //   const Profile(),
  // ];

  // TODO : Fix this
  // Widgets and their corresponding tab index
  final Map<int, Widget> screens = HashMap();

  void initTabs() {
    screens[0] = const Movies();
    screens[1] = const Recommandation();
    screens[2] = const Favorites();
    screens[3] = const Profile();
  }

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Movies();

  @override
  Widget build(BuildContext context) {
    // Init tabs at first build
    initTabs();

  // Use Expanded to make the bottom navigation bar
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Movies();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie,
                          color: currentTab == 0 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Movies',
                          style: TextStyle(
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Recommandation();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie,
                          color: currentTab == 1 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Movies',
                          style: TextStyle(
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Favorites();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie,
                          color: currentTab == 2 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Movies',
                          style: TextStyle(
                            color: currentTab == 2 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Profile();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.movie,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        Text(
                          'Movies',
                          style: TextStyle(
                            color: currentTab == 3 ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderMaterialBtn(String text, Icon icon) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(() {
          currentScreen = const Movies();
          currentTab = 0;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie,
            color: currentTab == 0 ? Colors.blue : Colors.grey,
          ),
          Text(
            'Movies',
            style: TextStyle(
              color: currentTab == 0 ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderBtnIcon(Icon icon) {
    return Icon(
      Icons.movie,
      color: currentTab == 0 ? Colors.blue : Colors.grey,
    );
  }

  Widget _renderBtnText(String text, int tab) {
    return Text(
      text,
      style: TextStyle(
        color: currentTab == tab
            ? BaseStyles.primaryColor
            : BaseStyles.darkShade_2,
      ),
    );
  }

  Widget _renderBtn(String text, Icon icon, int tab, Widget screen) {
    return GestureDetector(
      onTap: () => setState(() {
        currentScreen = screen;
        // TODO : Fix this (currentTab needs to equal to tab + 1), but problem renderBtnText
        currentTab = 0;
      }),
      child: Column(
        children: [
          _renderBtnIcon(icon),
          _renderBtnText(text, tab),
        ],
      ),
    );
  }
}
