// Basic and package imports
import 'package:cineflix/components/complex_card_builder.dart';
import 'package:cineflix/components/simple_card_builder.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models imports
import 'package:cineflix/models/movie.dart';
import 'package:cineflix/models/api_search_response.dart';

// Pages imports
import 'package:cineflix/pages/search.dart';

// Components imports
import 'package:cineflix/components/navigation.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  MoviesState createState() => MoviesState();
}

class MoviesState extends State<Movies> {
  /// ************************************************************************************ ///
  /// ***************************** Utils and initialization ***************************** ///
  /// ************************************************************************************ ///

  // Shared preferences
  late SharedPreferences _prefs;

  // Search bar text field controller (to clear the field)
  final searchBarField = TextEditingController();

  // Associated method to clear the search bar text field
  void clearSearchBar() {
    searchBarField.clear();
  }

  // Selected movies id
  final selectedMoviesId = [550, 1372, 78, 393, 324825];

  // Selected & trendy movies
  List<Movie> trendyMovies = [];
  List<Movie> selectedMovies = [];

  // Fetch the list of all watched movies id (from the shared preferences) if null, set it to an empty list by default
  List<String> _watchedMovies = [];

  // Is loading
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  // Init method : render trendy movies and selected movies
  void init() async {
    // Init shared preferences
    await _initSharedPreferences();

    // Render trendy movies
    await _initTrendyMovies();

    // Render selected movies
    await _initSelectedMovies();

    // Fetch the list of all watched movies id (from the shared preferences) if null, set it to an empty list by default
    _watchedMovies = _prefs.getStringList("watched_movies") ?? [];

    setState(() => _isLoading = false);
  }

  // Init shared preferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Take the 10 first movies from the API response and set the trendy movies
  Future<void> _initTrendyMovies() async {
    APISearchResponse apiSearchResponse =
        await APISearchResponse.fetchPopularMovies();

    setState(() => trendyMovies = apiSearchResponse.results.take(10).toList());
  }

  // Load the selected movies
  Future<void> _initSelectedMovies() async {
    List<Movie> selectedMoviesFromAPI = [];
    for (int i = 0; i < selectedMoviesId.length; i++) {
      Movie movie = await Movie.fetchMovieById(selectedMoviesId[i]);
      selectedMoviesFromAPI.add(movie);
    }

    setState(() => selectedMovies = selectedMoviesFromAPI);
  }

  // Navigate to the search page (impossible to use a component because of the controller (searchBarField))
  void _navigationToSearchedMovies(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Search(
                  searchQuery: searchBarField.text,
                )));
  }

  /// ********************************************************************** ///
  /// ***************************** Build page ***************************** ///
  /// ********************************************************************** ///

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LinearProgressIndicator(
          backgroundColor: BaseStyles.darkShade_1, color: BaseStyles.lightBlue);
    } else {
      return RefreshIndicator(
          onRefresh: () async => init(),
          child: SingleChildScrollView(child: _renderPage(context)));
    }
  }

  Widget _renderPage(BuildContext context) {
    return GestureDetector(
      // Unfocus the text field when the user tap on the screen (to hide the keyboard)
      onTap: FocusScope.of(context).unfocus,
      child: Padding(
        padding: const EdgeInsets.only(
            top: BaseStyles.spacing_6, bottom: BaseStyles.spacing_6),
        child: Column(
          children: [
            _renderAppHeader(),
            StickyHeader(
                header: _renderSearchBar(context),
                content: Column(children: [
                  _renderTrendySection(),
                  _renderSelectedSection(context),
                ])),
          ],
        ),
      ),
    );
  }

  /// ************************************************************************************************ ///
  /// ***************************** Render app header and the search bar ***************************** ///
  /// ************************************************************************************************ ///

  // Render methods
  Widget _renderAppHeader() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_2),
      child: Column(
        children: [
          Text(
            "Cineflix",
            style: BaseStyles.appTitle,
          ),
          Text(
            "What are we watching today ?",
            style: BaseStyles.text,
          ),
        ],
      ),
    );
  }

  // Search bar (impossible to use a component because of the controller (clearSearchBar method ))
  Widget _renderSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_6, BaseStyles.spacing_3, BaseStyles.spacing_3),
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
                          // Navigate to the searched movies page
                          _navigationToSearchedMovies(context),

                          // Lose focus on the search bar
                          FocusScope.of(context).unfocus,
                        }
                    }, // Check if the search bar is not empty to navigate to the searched movies page
                decoration: InputDecoration(
                    // Icon
                    prefixIcon: IconButton(
                      icon: const Icon(FeatherIcons.search),
                      color: BaseStyles.white,
                      onPressed: () => {
                        // Navigate to the searched movies page
                        _navigationToSearchedMovies(context),

                        // Lose focus on the search bar
                        FocusScope.of(context).unfocus,
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
                      borderSide:
                          BorderSide(color: BaseStyles.white, width: 2.0),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(BaseStyles.spacing_10)),
                    ),

                    // Filled + fillColor
                    filled: true,
                    fillColor: BaseStyles.darkShade_1,
                    suffixIcon: IconButton(
                        icon: const Icon(FeatherIcons.x),
                        color: BaseStyles.white,
                        onPressed: clearSearchBar)))),
      ]),
    );
  }

  /// ********************************************************************************* ///
  /// *************************** Render the trendy section *************************** ///
  /// ********************************************************************************* ///
  Widget _renderTrendySection() {
    return Column(
      children: [
        _renderTrendySectionTitle(), // Trendy
        _renderTrendyMovies(), // Trendy movies
      ],
    );
  }

  // Render the Trendy section title
  Widget _renderTrendySectionTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_4, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: Row(
        children: [
          Text(
            "Trendy",
            style: BaseStyles.h2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  // Render the Trendy section movies
  Widget _renderTrendyMovies() {
    return SizedBox(
      height: MovieStyles.simpleMovieCardHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(BaseStyles.spacing_2),
        itemCount: trendyMovies.length,
        itemBuilder: _simpleMovieCardBuilder,
      ),
    );
  }

  // Render a simple movie card : image + title
  Widget _simpleMovieCardBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: GestureDetector(
        onTap: () =>
            Navigation.navigationToMovieDetail(context, trendyMovies[index].id),
        child: Column(
          children: [
            SimpleCardBuilder.renderSimpleCardImage(
                trendyMovies[index].poster_path),
            SimpleCardBuilder.renderSimpleCardTitle(
                trendyMovies[index].original_title),
          ],
        ),
      ),
    );
  }

  /// ******************************************************************************************* ///
  /// ***************************  Render the selected movies section *************************** ///
  /// ******************************************************************************************* ///

  // Render the selected movies section
  Widget _renderSelectedSection(BuildContext context) {
    return Column(
      children: [
        _renderSelectedMoviesTitle(), // Selected movies
        _renderSelectedMoviesList(context), // Selected movies list
      ],
    );
  }

  // Render the Selected movies section title
  Widget _renderSelectedMoviesTitle() {
    return Container(
      margin: const EdgeInsets.fromLTRB(BaseStyles.spacing_3,
          BaseStyles.spacing_2, BaseStyles.spacing_3, BaseStyles.spacing_1),
      child: Row(
        children: [
          Text(
            "Our selection",
            style: BaseStyles.h2,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _renderSelectedMoviesList(BuildContext context) {
    return Column(
      children: [
        // Render the 5 selected movies
        for (int i = 0; i < selectedMovies.length; i++)
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

  // Render the Selected movies section list : image + title + rating + description + watch/unwatch icon
  Widget _complexMovieCardBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () =>
          Navigation.navigationToMovieDetail(context, selectedMovies[index].id),
      child: SizedBox(
        height: MovieStyles.complexMovieCardHeight,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            // Movie image
            ComplexCardBuilder.renderMovieComplexCardImage(
                selectedMovies[index].poster_path),
            // Separator between the image and the info
            const SizedBox(width: BaseStyles.spacing_3),
            // Movie info
            ComplexCardBuilder.renderMovieComplexCardInfo(
                selectedMovies[index].original_title,
                selectedMovies[index].vote_average,
                _watchedMovies.contains(selectedMovies[index].id.toString()),
                selectedMovies[index].overview),
          ],
        ),
      ),
    );
  }
}
