class TrendingMoviesPoster {
  final String? posterPath;
  final int id;
  final String? title;
  TrendingMoviesPoster({required this.posterPath, required this.id, this.title});

  factory TrendingMoviesPoster.fromJson(Map<String, dynamic> json) {
    return TrendingMoviesPoster(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
    );
  }
}

class TrendingMovies {
  List<TrendingMoviesPoster> results;

  TrendingMovies({required this.results});

  factory TrendingMovies.fromJson(Map<String, dynamic> json) => TrendingMovies(
    results: (json['results'] as List)
        .map((e) => TrendingMoviesPoster.fromJson(e))
        .toList(),
  );
}
