class TvShowDetailsData {
  final String? posterPath;
  final String? originalTitle;
  final String? overview;
  final DateTime? releaseDate;
  final int? id;
  final int? runtime;
  final List<String>? genres;

  TvShowDetailsData({
    this.posterPath,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.id,
    this.runtime,
    this.genres,
  });

  factory TvShowDetailsData.fromJson(Map<String, dynamic> json) {
    return TvShowDetailsData(
      id: json['id'],
      posterPath: json['poster_path'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'] != null
          ? DateTime.parse(json['release_date'] as String)
          : null,
      runtime: json['runtime'],
      genres: json['genres'] != null
          ? (json['genres'] as List<dynamic>)
              .map((e) => e['name'] as String)
              .toList()
          : null,
    );
  }
}
