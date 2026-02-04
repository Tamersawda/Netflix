class TopRatedmoviesPoster {
  final String? posterPath;
  final int id;
  TopRatedmoviesPoster({required this.posterPath, required this.id});

  factory TopRatedmoviesPoster.fromJson(Map<String, dynamic> json) {
    return TopRatedmoviesPoster(
      id: json['id'],
      posterPath: json['poster_path'],
    );
  }
}

class TopRatedMovies {
  List<TopRatedmoviesPoster> results;

  TopRatedMovies({required this.results});

  factory TopRatedMovies.fromJson(Map<String, dynamic> json) => TopRatedMovies(
    results: (json['results'] as List)
        .map((e) => TopRatedmoviesPoster.fromJson(e))
        .toList(),
  );
}
