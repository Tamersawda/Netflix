class SearchMoviesPoster {
  final String? posterPath;
  final int id;
  final String? title;

  SearchMoviesPoster({
    required this.posterPath,
    required this.id,
    this.title
  });

  factory SearchMoviesPoster.fromJson(Map<String, dynamic> json) {
    return SearchMoviesPoster(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
      );
  }
}

class SearchMovies {
  List<SearchMoviesPoster> results;

  SearchMovies({required this.results});

  factory SearchMovies.fromJson(Map<String, dynamic> json) => SearchMovies(
    results: (json['results'] as List)
        .map((e) => SearchMoviesPoster.fromJson(e))
        .toList(),
  );
}
