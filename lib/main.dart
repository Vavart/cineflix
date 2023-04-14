import 'package:flutter/material.dart';
import 'package:cineflix/home.dart';

void main() {
  runApp(const CineflixApp());
}

class CineflixApp extends StatelessWidget {
  const CineflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cineflix",
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
