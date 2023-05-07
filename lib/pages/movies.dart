// Basic imports
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Models imports
import 'package:cineflix/models/movie.dart';
import 'package:cineflix/models/api_search_response.dart';

// Pages imports
import 'package:cineflix/pages/search.dart';
import 'package:cineflix/pages/movie_detail.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  MoviesState createState() => MoviesState();
}

class MoviesState extends State<Movies> {
  // Shared preferences
  late SharedPreferences _prefs;

  // Search bar text field controller (to clear the field)
  final searchBarField = TextEditingController();

  // Associated method to clear the search bar text field
  void clearSearchBar() {
    searchBarField.clear();
  }

  // Selected movies id
  final selectedMoviesId = [550, 1372, 78, 24, 324825];

  // Selected & trendy movies
  List<Movie> trendyMovies = [];
  List<Movie> selectedMovies = [];

  // API url to get images
  final String _apiImageUrl = "https://image.tmdb.org/t/p/original";

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

  // Navigation methods
  void _navigationToMovieDetail(BuildContext context, int index) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MovieDetail(movieID: index)));
  }

  void _navigationToSearchedMovies(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Search(
                  searchQuery: searchBarField.text,
                )));
  }

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
    return Padding(
      padding: const EdgeInsets.only(
          top: BaseStyles.spacing_6, bottom: BaseStyles.spacing_6),
      child: Column(
        children: [
          _renderFullSearchBar(context),
          _renderTrendySection(),
          _renderSelectedSection(context),
        ],
      ),
    );
  }

  /// ********************************************************************************* ///
  /// ***************************** Render the search bar ***************************** ///
  /// ********************************************************************************* ///

  // Render methods
  Widget _renderFullSearchBar(BuildContext context) {
    return Column(
      children: [
        _renderTextSearchBar(),
        _renderSearchBar(context),
      ],
    );
  }

  Widget _renderTextSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_3, vertical: 0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "What are we watching today ?",
          style: BaseStyles.text,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _renderSearchBar(BuildContext context) {
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
                      if (value.isNotEmpty) _navigationToSearchedMovies(context)
                    }, // Check if the search bar is not empty to navigate to the searched movies page
                decoration: InputDecoration(
                    // Icon
                    prefixIcon: IconButton(
                      icon: const Icon(FeatherIcons.search),
                      color: BaseStyles.white,
                      onPressed: () => _navigationToSearchedMovies(context),
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
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Trendy",
          style: BaseStyles.h2,
          textAlign: TextAlign.left,
        ),
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
        onTap: () => _navigationToMovieDetail(context, trendyMovies[index].id),
        child: Column(
          children: [
            _renderMovieSimpleCardImage(index),
            _renderMovieSimpleCardTitle(index),
          ],
        ),
      ),
    );
  }

  Widget _renderMovieSimpleCardImage(int index) {
    FadeInImage imageFadeIn;

    if (trendyMovies[index].poster_path != null) {
      imageFadeIn = FadeInImage(
        image: NetworkImage(
          _apiImageUrl + trendyMovies[index].poster_path!,
        ),
        placeholder: const AssetImage("assets/images/no_movie_preview.png"),
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    } else {
      imageFadeIn = const FadeInImage(
        image: AssetImage(
          "assets/images/no_movie_preview.png",
        ),
        placeholder: AssetImage("assets/images/no_movie_preview.png"),
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
      child: imageFadeIn,
    );
  }

  Widget _renderMovieSimpleCardTitle(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MovieStyles.simpleMovieCardTitleWidth,
      child: Text(
        trendyMovies[index].original_title,
        style: BaseStyles.boldSmallText,
        textAlign: TextAlign.center,
        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
      child: SizedBox(
        width: double.infinity,
        child: Text(
          "Our selection",
          style: BaseStyles.h2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _renderSelectedMoviesList(BuildContext context) {
    return Column(
      children: [
        // Render the 5 selected movies (for loop because ListView.builder doesn't work with Column (unbounded height issues))
        for (int i = 0; i < selectedMovies.length; i++)
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
      onTap: () => _navigationToMovieDetail(context, selectedMovies[index].id),
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
    if (selectedMovies[index].poster_path != null) {
      image = Image.network(
        _apiImageUrl + selectedMovies[index].poster_path!,
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
        child: image);
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
    return Text(
      selectedMovies[index].original_title,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: BaseStyles.boldText,
    );
  }

  Widget _renderMovieComplexCardIcons(int index) {
    return Row(
      children: [
        _renderMovieComplexCardRating(index),
        _renderMovieComplexCardWatchIcon(index),
      ],
    );
  }

  Widget _renderMovieComplexCardRating(int index) {
    int rating = (selectedMovies[index].vote_average * 10).toInt();
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

  Widget _renderMovieComplexCardWatchIcon(int index) {
    //
    IconData icon = _watchedMovies.contains(selectedMovies[index].id.toString())
        ? FeatherIcons.checkCircle
        : FeatherIcons.eyeOff;

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      child: Icon(
        icon,
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
        selectedMovies[index].overview,
        style: BaseStyles.smallText,
        textAlign: TextAlign.left,

        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
