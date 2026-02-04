class FavoriteMoviesPoster {
  final String? posterPath;
  final int id;
  FavoriteMoviesPoster({required this.posterPath, required this.id});

  factory FavoriteMoviesPoster.fromJson(Map<String, dynamic> json) {
    return FavoriteMoviesPoster(
      id: json['id'],
      posterPath: json['poster_path']
      );
  }
}

class FavoriteMovies {
  List<FavoriteMoviesPoster> results;

  FavoriteMovies({required this.results});

  factory FavoriteMovies.fromJson(Map<String, dynamic> json) => FavoriteMovies(
    results: (json['results'] as List)
        .map((e) => FavoriteMoviesPoster.fromJson(e))
        .toList(),
  );
}