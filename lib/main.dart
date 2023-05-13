// Basics imports
import 'package:flutter/material.dart';

// Homepage import
import 'package:cineflix/home.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';

void main() {
  runApp(const CineflixApp());
}

class CineflixApp extends StatelessWidget {
  const CineflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cineflix",
      home: const Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: BaseStyles.primaryColor,
      ),
    );
  }
}
