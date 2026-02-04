class FavoriteTvShowsPoster {
  final String? posterPath;
  final int id;
  FavoriteTvShowsPoster({required this.posterPath, required this.id});

  factory FavoriteTvShowsPoster.fromJson(Map<String, dynamic> json) {
    return FavoriteTvShowsPoster(
      id: json['id'],
      posterPath: json['poster_path']
      );
  }
}

class FavoriteTvShows {
  List<FavoriteTvShowsPoster> results;

  FavoriteTvShows({required this.results});

  factory FavoriteTvShows.fromJson(Map<String, dynamic> json) => FavoriteTvShows(
    results: (json['results'] as List)
        .map((e) => FavoriteTvShowsPoster.fromJson(e))
        .toList(),
  );
}