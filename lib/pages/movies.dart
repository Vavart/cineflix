import 'package:flutter/material.dart';

class Movies extends StatelessWidget {
  const Movies({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
      ),
      body: const Center(
        child: Text('Movies'),
      ),
    );
  }

}