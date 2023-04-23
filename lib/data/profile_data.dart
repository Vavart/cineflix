import 'package:cineflix/models/profile_facts.dart';

class ProfileData {
  static final List<ProfileFacts> facts = [
    ProfileFacts(title: "About Cineflix", facts: [
      "Cineflix is a mobile app based on Flutter. It allows the user to search movies and save them as favorites.",
      "On each film page, the user can watch the trailer (= movie homepage redirection) and share the movie on social medias and messaging apps.",
      "The user can also mark the film as watched or unwatched.",
      "An AI model is embedded into the app, making suggestions to the user based on its preferences (= favorites) and popular movies."
    ]),
    ProfileFacts(title: "Thanks", facts: [
      "I would like to thanks Julien Ratouit for giving me 5 must-watch movies for the app selection."
    ]),
  ];
}
