// Basic imports
import 'package:flutter/material.dart';

// Style imports
import 'package:cineflix/styles/base.dart';
import 'package:cineflix/styles/profile.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:cineflix/styles/movies.dart';

// Data imports
import 'package:cineflix/data/profile_data.dart';

// Model imports
import 'package:cineflix/models/profile_facts.dart';

// Component imports
import 'package:cineflix/components/utils.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _renderPage()),
    );
  }

  // Render methods

  Widget _renderPage() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_2),
      child: Column(
        children: [_renderHeader(), _renderFacts(), _renderLinks()],
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_6),
      child: Column(
        children: <Widget>[
          _renderHeaderPic(),
          _renderHeaderText(),
        ],
      ),
    );
  }

  Widget _renderHeaderPic() {
    return SizedBox(
      width: ProfileStyle.imgWidth,
      height: ProfileStyle.imgHeight,
      child: Image.asset(Utils.authorPicURI),
    );
  }

  Widget _renderHeaderText() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_2),
      child: Text(
        "Maxime Sciare",
        style: BaseStyles.h1,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _renderFacts() {
    return Container(
      margin: const EdgeInsets.only(top: BaseStyles.spacing_6),
      child: Column(
        children: [
          for (var facts in ProfileData.facts) _renderFact(facts),
        ],
      ),
    );
  }

  Widget _renderFact(ProfileFacts facts) {
    return Container(
      margin: const EdgeInsets.only(bottom: BaseStyles.spacing_4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderFactTitle(facts.title),
          _renderFactList(facts.facts),
        ],
      ),
    );
  }

  Widget _renderFactTitle(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
          BaseStyles.spacing_4, 0, BaseStyles.spacing_4, BaseStyles.spacing_2),
      child: Text(
        title,
        style: BaseStyles.h2,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _renderFactList(List<String> facts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var fact in facts) _renderFactItem(fact),
      ],
    );
  }

  Widget _renderFactItem(String fact) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        BaseStyles.spacing_4,
        BaseStyles.spacing_2,
        BaseStyles.spacing_4,
        BaseStyles.spacing_2,
      ),
      child: Text(
        fact,
        style: BaseStyles.text,
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _renderLinks() {
    return Container(
      margin: const EdgeInsets.only(
          top: BaseStyles.spacing_2, bottom: BaseStyles.spacing_7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _renderLink("My website", Utils.maximeWebsiteURL),
          const SizedBox(width: BaseStyles.spacing_3),
          _renderLink("Julien's website", Utils.julienWebsiteURL),
        ],
      ),
    );
  }

  Widget _renderLink(String text, String uri) {
    return TextButton(
        onPressed: () => Utils.openURL(uri),
        style: BaseStyles.ctaButtonStyle,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: BaseStyles.spacing_1, horizontal: BaseStyles.spacing_2),
          child: Row(
            children: [
              Text(
                text,
                style: BaseStyles.boldSmallText,
              ),
              // Add a space between the icon and the text
              const SizedBox(width: BaseStyles.spacing_1),
              Icon(
                FeatherIcons.externalLink,
                color: BaseStyles.lightBlue,
                size: MovieStyles.movieCTAIconSize,
              ),
            ],
          ),
        ));
  }
}