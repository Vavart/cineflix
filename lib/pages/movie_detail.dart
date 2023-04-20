// Basic imports
import 'package:flutter/material.dart';

class MovieDetail extends StatefulWidget {
  final int movieID;
  const MovieDetail({super.key, required this.movieID});

  @override
  // ignore: no_logic_in_create_state
  createState() => _MovieDetail(movieID: movieID);
}

class _MovieDetail extends State<MovieDetail> {

  final int movieID;
  _MovieDetail({required this.movieID});

  @override
  void initState() {
    super.initState();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Movie detail $movieID")),
    );
  }
}
