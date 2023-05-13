// Basic and packages import
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';
import 'package:feather_icons/feather_icons.dart';

// Components imports
import 'package:cineflix/components/utils.dart';

class ComplexCardBuilder {
    static Widget renderMovieComplexCardImage(String? posterPath) {
    // If the movie has a poster
    if (posterPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: CachedNetworkImage(
          imageUrl: Utils.apiImageURL + posterPath,
          placeholder: (context, url) {
            return Center(
              child: SizedBox(
                  width: BaseStyles.spacing_5,
                  height: BaseStyles.spacing_5,
                  child: CircularProgressIndicator(
                    color: BaseStyles.lightBlue,
                    strokeWidth: BaseStyles.spacing_1,
                  )),
            );
          },

          // If the image fails to load display a default image instead
          errorWidget: (context, url, error) {
            return Image(
              image: AssetImage(Utils.noMoviePreviewURI),
              width: MovieStyles.movieCardImgWidth,
              height: MovieStyles.movieCardImgHeight,
              fit: BoxFit.cover,
            );
          },
          width: MovieStyles.movieCardImgWidth,
          height: MovieStyles.movieCardImgHeight,
          fit: BoxFit.cover,
        ),
      );

      // If the movie has no poster
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: Image(
        image: AssetImage(Utils.noMoviePreviewURI),
        width: MovieStyles.movieCardImgWidth,
        height: MovieStyles.movieCardImgHeight,
        fit: BoxFit.cover,));
    }
  }

  static Widget renderMovieComplexCardInfo(String title, double rating, bool isWatched, String description) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComplexCardBuilder.renderMovieComplexCardTitle(title),
          ComplexCardBuilder.renderMovieComplexCardIcons(rating, isWatched),
          ComplexCardBuilder.renderMovieComplexCardDescription(description),
        ],
      ),
    );
  }

  static Widget renderMovieComplexCardTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: BaseStyles.boldText,
    );
  }

  static Widget renderMovieComplexCardIcons(double rating, bool isWatched) {
    return Row(
      children: [
        ComplexCardBuilder.renderMovieComplexCardRating(rating),
        ComplexCardBuilder.renderMovieComplexCardWatchIcon(isWatched),
      ],
    );
  }

  static Widget renderMovieComplexCardRating(double movieRating) {
    int rating = (movieRating * 10).toInt();
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

  static Widget renderMovieComplexCardWatchIcon(bool isWatched) {
    //
    IconData icon = isWatched
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

  static Widget renderMovieComplexCardDescription(String description) {
    return Text(
      description,
      style: BaseStyles.smallText,
      textAlign: TextAlign.left,
      // Limit the number of lines to 4 and add an ellipsis if the text is too long
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}