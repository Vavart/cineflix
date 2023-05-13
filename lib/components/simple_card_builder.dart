// Basic import
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Styles imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/movies.dart';

// Components imports
import 'package:cineflix/components/utils.dart';

class SimpleCardBuilder {

  // Render the image of a simple card
  static Widget renderSimpleCardImage(String? posterPath) {
    // If the movie has a poster display it
    if (posterPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: CachedNetworkImage(
          imageUrl: Utils.apiImageURL + posterPath,

          // While the image is loading display a loading indicator
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
    }

    // If the movie has no poster display a default image instead
    else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(BaseStyles.spacing_1),
        child: Image(
          image: AssetImage(Utils.noMoviePreviewURI),
          width: MovieStyles.movieCardImgWidth,
          height: MovieStyles.movieCardImgHeight,
          fit: BoxFit.cover,
        ),
      );
    }
  }

  // Render the title of a simple card
  static Widget renderSimpleCardTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: BaseStyles.spacing_1, vertical: BaseStyles.spacing_1),
      width: MovieStyles.simpleMovieCardTitleWidth,
      child: Text(
        title,
        style: BaseStyles.boldSmallText,
        textAlign: TextAlign.center,
        // Limit the number of lines to 2 and add an ellipsis if the text is too long
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Widget renderSimpleCardSubtitle(String subtitle) {
    return Text(
      subtitle,
      style: BaseStyles.smallText,
      textAlign: TextAlign.center,

      // Limit the number of lines to 2 and add an ellipsis if the text is too long
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}