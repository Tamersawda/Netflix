class PopularTvShowsPoster {
  final String? posterPath;
  final int id;
  final String? title;
  PopularTvShowsPoster({required this.posterPath, required this.id, this.title});

  factory PopularTvShowsPoster.fromJson(Map<String, dynamic> json) {
    return PopularTvShowsPoster(
      id: json['id'],
      posterPath: json['poster_path'],
      title: json['original_name'],
      );
  }
}

class PopularTvShows {
  List<PopularTvShowsPoster> results;

  PopularTvShows({required this.results});

  factory PopularTvShows.fromJson(Map<String, dynamic> json) => PopularTvShows(
    results: (json['results'] as List)
        .map((e) => PopularTvShowsPoster.fromJson(e))
        .toList(),
  );
}
