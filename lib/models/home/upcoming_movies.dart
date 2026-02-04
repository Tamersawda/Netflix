class UpcomingMoviePoster {
  final String? posterPath;
  final int id;
  final String? title;
  final String? releaseDate;
  final String? overview;

  UpcomingMoviePoster({required this.posterPath, required this.id, this.title, this.releaseDate, this.overview});

  factory UpcomingMoviePoster.fromJson(Map<String, dynamic> json) {
    return UpcomingMoviePoster(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
    );
  }
}

class UpcomingMovies {
  List<UpcomingMoviePoster> results;

  UpcomingMovies({required this.results});

  factory UpcomingMovies.fromJson(Map<String, dynamic> json) => UpcomingMovies(
    results: (json['results'] as List)
        .map((e) => UpcomingMoviePoster.fromJson(e))
        .toList(),
  );
}