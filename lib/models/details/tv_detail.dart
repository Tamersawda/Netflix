class TvSeason {
  final int? seasonNumber;
  final String? name;
  final String? posterPath;
  final int? episodeCount;

  TvSeason({
    this.seasonNumber,
    this.name,
    this.posterPath,
    this.episodeCount,
  });

  factory TvSeason.fromJson(Map<String, dynamic> json) {
    return TvSeason(
      seasonNumber: json['season_number'],
      name: json['name'],
      posterPath: json['poster_path'],
      episodeCount: json['episode_count'],
    );
  }
}

class TvDetailScreenData {
  final int id;
  final String? originalName;
  final String? overview;
  final String? posterPath;
  final DateTime? firstAirDate;
  final List<String>? genres;
  final List<int>? episodeRunTime;
  final List<TvSeason>? seasons;

  TvDetailScreenData({
    required this.id,
    this.originalName,
    this.overview,
    this.posterPath,
    this.firstAirDate,
    this.genres,
    this.episodeRunTime,
    this.seasons,
  });

  factory TvDetailScreenData.fromJson(
      Map<String, dynamic> json) {
    return TvDetailScreenData(
      id: json['id'],
      originalName: json['original_name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      firstAirDate: json['first_air_date'] != null
          ? DateTime.parse(json['first_air_date'])
          : null,
      genres: (json['genres'] as List?)
          ?.map((g) => g['name'] as String)
          .toList(),
      episodeRunTime:
          (json['episode_run_time'] as List?)
              ?.map((e) => e as int)
              .toList(),
      seasons: (json['seasons'] as List?)
          ?.map((s) =>
              TvSeason.fromJson(s))
          .toList(),
    );
  }
}
