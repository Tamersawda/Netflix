class MoviesPoster {
  final String? posterPath;
  final int id;
  MoviesPoster({required this.posterPath, required this.id});

  factory MoviesPoster.fromJson(Map<String, dynamic> json) {
    return MoviesPoster(
      id: json['id'],
      posterPath: json['poster_path']
      );
  }
}

class MovieRecommendations {
  List<MoviesPoster> results;

  MovieRecommendations({required this.results});

  factory MovieRecommendations.fromJson(Map<String, dynamic> json) => MovieRecommendations(
    results: (json['results'] as List)
        .map((e) => MoviesPoster.fromJson(e))
        .toList(),
  );
}