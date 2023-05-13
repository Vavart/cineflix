// Basic and packages imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models import
import 'package:cineflix/models/api_search_response.dart';
import "package:cineflix/models/movie.dart";

// Components imports
import 'package:cineflix/components/complex_card_builder.dart';
import 'package:cineflix/components/navigation.dart';

class Search extends StatefulWidget {
  // Search query
  final String searchQuery;
  const Search({super.key, required this.searchQuery});

  @override
  // ignore: no_logic_in_create_state
  createState() => SearchState(searchQuery);
}

class SearchState extends State<Search> {
  // Shared preferences
  late SharedPreferences _prefs;

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

  // Fetch the list of all watched movies id (from the shared preferences) if null, set it to an empty list by default
  List<String> _watchedMovies = [];

  // Is loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    searchBarField.text = searchQuery;
    _init();
  }

  void _init() async {
    setState(() => isLoading = true);

    // Init shared preferences
    await _initSharedPreferences();

    // Init searched movies (from the API with the search query)
    await _initSearchedMovies();

    // Fetch the list of all watched movies id (from the shared preferences) if null, set it to an empty list by default
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    setState(() => isLoading = false);
  }

  // Init shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Init searched movies (from the API with the search query)
  Future<void> _initSearchedMovies() async {
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchMovieBySearch(searchQuery);
    setState(
        () => searchedMovies = apiSearchResponse.results.take(15).toList());
  }

  // Update the search query (and refresh the page with the new search query)
  void updateQuery(String newQuery) {
    searchQuery = newQuery;
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: BaseStyles.spacing_8),
        child: Center(
          child: SizedBox(
            height: 100.0,
            width: 100.0,
            child: CircularProgressIndicator(
              backgroundColor: BaseStyles.darkShade_1,
              color: BaseStyles.darkBlue,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: BaseStyles.primaryColor,
          title: Text('Search : $searchQuery'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: BaseStyles.spacing_2,
                vertical: BaseStyles.spacing_4),
            child: Column(
              children: [
                StickyHeader(
                  header: _renderSearchBar(),
                  content: _renderSearchedMovies(context),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  /// ********************************************************************************* ///
  /// ***************************** Render the search bar ***************************** ///
  /// ********************************************************************************* ///
  
  // Search bar (impossible to use a component because of the controller (clearSearchBar method ))
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
                    if (value.isNotEmpty)
                      {
                        // Refresh the page with the new search query
                        setState(() => updateQuery(value)),

                        // Lose the focus on the search bar
                        FocusScope.of(context).unfocus(),
                      }
                  }, // Update the search query if the user submit a new one and the field is not empty
              decoration: InputDecoration(
                  // Icon
                  prefixIcon: IconButton(
                    icon: const Icon(FeatherIcons.search),
                    color: BaseStyles.white,
                    onPressed: () {
                      if (searchBarField.text.isNotEmpty) {
                        // Refresh the page with the new search query
                        setState(() => updateQuery(searchBarField.text));

                        // Lose the focus on the search bar
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  prefixIconColor: BaseStyles.white,

                  // Placeholder
                  hintText: "Search...",
                  hintStyle: BaseStyles.placeholder,

                  // Content padding
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: BaseStyles.spacing_3,
                      horizontal: BaseStyles.spacing_3),

                  // No border
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: BaseStyles.primaryColor, width: 0),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(BaseStyles.spacing_10)),
                  ),

                  // No border
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: BaseStyles.primaryColor, width: 0),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(BaseStyles.spacing_10)),
                  ),

                  // But focus border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: BaseStyles.white, width: 2.0),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(BaseStyles.spacing_10)),
                  ),

                  // Filled + fillColor
                  filled: true,
                  fillColor: BaseStyles.darkShade_1,
                  suffixIcon: IconButton(
                      icon: const Icon(FeatherIcons.x),
                      color: BaseStyles.white,
                      onPressed: clearSearchBar))),
        ),
      ]),
    );
  }

  /// ********************************************************************************** ///
  /// ***************************** Render searched movies ***************************** ///
  /// ********************************************************************************** ///

  Widget _renderSearchedMovies(BuildContext context) {
    // If the searched movies list is empty, display a message
    if (searchedMovies.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: BaseStyles.spacing_3, vertical: BaseStyles.spacing_3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flexible to make the text wrap if the search query is too long
            Flexible(
              child: Text(
                "We couldn't find any movies for $searchQuery 😢\n\nTry another search !",
                style: BaseStyles.text,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } 
    
    // Else, display the searched movies list
    else {
      return Column(
        children: [
          _renderSelectedMoviesList(context), // Selected movies list
        ],
      );
    }
  }

  // Render the searched movies list
  Widget _renderSelectedMoviesList(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < searchedMovies.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(
                BaseStyles.spacing_3,
                BaseStyles.spacing_2,
                BaseStyles.spacing_3,
                BaseStyles.spacing_1),
            child: _complexMovieCardBuilder(context, i),
          ),
      ],
    );
  }

  Widget _complexMovieCardBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () =>
          Navigation.navigationToMovieDetail(context, searchedMovies[index].id),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            // Movie image
            ComplexCardBuilder.renderMovieComplexCardImage(
                searchedMovies[index].poster_path),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_3),
            // Movie info
            ComplexCardBuilder.renderMovieComplexCardInfo(
                searchedMovies[index].original_title,
                searchedMovies[index].vote_average,
                _watchedMovies.contains(searchedMovies[index].id.toString()),
                searchedMovies[index].overview),
          ],
        ),
      ),
    );
  }
}
