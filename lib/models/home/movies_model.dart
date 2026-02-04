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

class Movies {
  List<MoviesPoster> results;

  Movies({required this.results});

  factory Movies.fromJson(Map<String, dynamic> json) => Movies(
    results: (json['results'] as List)
        .map((e) => MoviesPoster.fromJson(e))
        .toList(),
  );
}
