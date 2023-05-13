// Imports
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static String apiImageURL = "https://image.tmdb.org/t/p/original";
  static String noMoviePosterURI =
      "assets/images/no_movie_illustration_preview.png";
  static String noMoviePreviewURI = "assets/images/no_movie_preview.png";
  static String noActorPreviewURI = "assets/images/no_actor_preview.png";
  static String authorPicURI = "assets/images/authorPic.png";

  static String maximeWebsiteURL = "https://maximesciare.com";
  static String julienWebsiteURL = "https://julien-ratouit.github.io/";

  // Launch movie trailer (when it's available)
  static Future<void> openURL(String url) async {
    Uri trailerUrl = Uri.parse(url);
    if (!await launchUrl(trailerUrl)) {
      throw Exception('Could not launch $trailerUrl');
    }
  }
}
