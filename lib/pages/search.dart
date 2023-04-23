// Basic imports
import 'package:flutter/material.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/search.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Pages imports
import '../models/api_search_response.dart';
import 'movie_detail.dart';

// Models import
import "package:cineflix/models/movie.dart";

class Search extends StatefulWidget {
  // Search query
  final String searchQuery;
  const Search({super.key, required this.searchQuery});

  @override
  // ignore: no_logic_in_create_state
  createState() => SearchState(searchQuery);
}

class SearchState extends State<Search> {
  // Search query
  String searchQuery;
  SearchState(this.searchQuery);

  // Search bar text field controller (to clear the field)
  final searchBarField = TextEditingController();

  // Associated method to clear the search bar text field
  void clearSearchBar() {
    searchBarField.clear();
  }

  // List of movies to display after the search
  List<Movie> searchedMovies = [];

  // API url to get images
  final String _apiImageUrl = "https://image.tmdb.org/t/p/original";

  @override
  void initState() {
    super.initState();
    searchBarField.text = searchQuery;
    init();
  }

  void init() async {
    await _initSearchedMovies();
  }

  Future<void> _initSearchedMovies() async {
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchMovieBySearch(searchQuery);
    setState(
        () => searchedMovies = apiSearchResponse.results.take(10).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BaseStyles.primaryColor,
        title: Text('Search : $searchQuery'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: BaseStyles.spacing_2, vertical: BaseStyles.spacing_4),
          child: Column(
            children: [
              _renderFullSearchBar(),
              _renderSearchedMovies(context),
            ],
          ),
        ),
      ),
    );
  }

  /// ********************************************************************************* ///
  /// ***************************** Render the search bar ***************************** ///
  /// ********************************************************************************* ///

  // Render methods
  Widget _renderFullSearchBar() {
    return Column(
      children: [
        _renderSearchBar(),
      ],
    );
  }

  Widget _renderSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_3),
      child: Row(children: [
        Flexible(
          child: TextField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: searchBarField,
              cursorColor: BaseStyles.white,
              style: BaseStyles.text,
              onSubmitted: (value) => {
                    if (value.isNotEmpty) setState(() => searchQuery = value)
                  }, // Update the search query if the user submit a new one and the field is not empty
              decoration: SearchStyles.searchBar),
        ),

        // Delete the search bar text field content
        TextButton(
          onPressed: clearSearchBar,
          child: Text(
            "Delete",
            style: BaseStyles.text,
          ),
        )
      ]),
    );
  }

  /// ********************************************************************************** ///
  /// ***************************** Render searched movies ***************************** ///
  /// ********************************************************************************** ///

  Widget _renderSearchedMovies(BuildContext context) {
    return Column(
      children: [
        _renderSelectedMoviesList(context), // Selected movies list
      ],
    );
  }

  Widget _renderSelectedMoviesList(BuildContext context) {
    return Column(
      children: [
        // Render the 5 selected movies (for loop because ListView.builder doesn't work with Column (unbounded height issues))
        for (int i = 0; i < searchedMovies.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                BaseStyles.spacing_3,
                BaseStyles.spacing_2,
                BaseStyles.spacing_3,
                BaseStyles.spacing_1),
            child: _complexMovieCard(context, i),
          ),
      ],
    );
  }

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexMovieCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => _navigationToMovieDetail(context, searchedMovies[index].id),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            _renderMovieComplexCardImage(index),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_3),
            _renderMovieComplexCardInfo(context, index),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieComplexCardImage(int index) {
    Image image;
    if (searchedMovies[index].poster_path != null) {
      image = Image.network(
        _apiImageUrl + searchedMovies[index].poster_path!,
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    } else {
      image = Image.asset(
        "assets/images/no_movie_preview.png",
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
      child: image,
    );
  }

  Widget _renderMovieComplexCardInfo(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _renderMovieComplexCardTitle(index),
        _renderMovieComplexCardIcons(index),
        _renderMovieComplexCardDescription(context, index),
      ],
    );
  }

  Widget _renderMovieComplexCardTitle(int index) {
    return SizedBox(
      width: MovieStyles.simpleMovieCardTitleWidth,
      child: Text(
        textAlign: TextAlign.left,
        searchedMovies[index].original_title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: BaseStyles.boldText,
      ),
    );
  }

  Widget _renderMovieComplexCardIcons(int index) {
    return Row(
      children: [
        _renderMovieComplexCardRating(index),
        _renderMovieComplexCardWatchIcon(),
      ],
    );
  }

  Widget _renderMovieComplexCardRating(int index) {
    int rating = (searchedMovies[index].vote_average * 10).toInt();
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Row(
        children: [
          Icon(
            FeatherIcons.star,
            color: BaseStyles.yellowStar,
          ),
          // Add a space between the icon and the text
          const SizedBox(width: BaseStyles.spacing_1),
          Text(
            "$rating %",
            style: BaseStyles.boldSmallYellowText,
          ),
        ],
      ),
    );
  }

  Widget _renderMovieComplexCardWatchIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Icon(
        FeatherIcons.eye,
        color: BaseStyles.lightBlue,
      ),
    );
  }

  Widget _renderMovieComplexCardDescription(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? 200.0
          : MediaQuery.of(context).size.width * 0.6,
      child: Text(
        searchedMovies[index].overview,
        style: BaseStyles.smallText,
        textAlign: TextAlign.left,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Navigation methods
  void _navigationToMovieDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }
}
