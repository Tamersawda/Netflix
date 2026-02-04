import 'package:dio/dio.dart';
import 'package:netflix_app/models/details/movie_recommendations.dart';
import 'package:netflix_app/models/details/movie_screen_data.dart';
import 'package:netflix_app/models/home/movies_model.dart';
import 'package:netflix_app/models/home/popular_tv_shows.dart';
import 'package:netflix_app/models/home/top_ratedmovies.dart';
import 'package:netflix_app/models/home/trending_movies.dart';
import 'package:netflix_app/models/home/upcoming_movies.dart';
import 'package:netflix_app/models/my_netflix/favorite_movies.dart';
import 'package:netflix_app/models/my_netflix/favorite_tv_shows.dart';
import 'package:netflix_app/models/search/search_movies.dart';
import 'package:netflix_app/services/api_key.dart';

class NetflixServices {
  late final Dio _dio;

  NetflixServices() {
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Authorization": "Bearer $READ_ACCESS_TOKEN",
          "accept": "application/json",
        },
      ),
    );
  }

  // MOVIES
  Future<Movies> fetchMovies() async {
    final response = await _dio.get("/movie/now_playing");
    return Movies.fromJson(response.data);
  }

  Future<UpcomingMovies> fetchUpcomingMovies() async {
    final response = await _dio.get("/movie/upcoming");
    return UpcomingMovies.fromJson(response.data);
  }

  Future<TrendingMovies> fetchTrendingMovies() async {
    final response = await _dio.get("/trending/movie/day");
    return TrendingMovies.fromJson(response.data);
  }

  Future<TopRatedMovies> fetchTopRatedMovies() async {
    final response = await _dio.get("/movie/top_rated");
    return TopRatedMovies.fromJson(response.data);
  }

  // FAVORITES (MOVIES)
  Future<FavoriteMovies> fetchFavoriteMovies(int accountId) async {
    final response = await _dio.get(
      "/account/$accountId/favorite/movies",
      queryParameters: {
        "language": "en-US",
        "sort_by": "created_at.desc",
      },
    );

    if (response.data is! Map<String, dynamic>) {
      throw Exception("Invalid response: ${response.data}");
    }

    return FavoriteMovies.fromJson(response.data);
  }

  // FAVORITES (TV)
  Future<FavoriteTvShows> fetchFavoriteTvShows(int accountId) async {
    final response = await _dio.get(
      "/account/$accountId/favorite/tv",
      queryParameters: {
        "language": "en-US",
        "sort_by": "created_at.desc",
      },
    );

    return FavoriteTvShows.fromJson(response.data);
  }

  // TV SHOWS
  Future<PopularTvShows> fetchPopularTvShows() async {
    final response = await _dio.get("/tv/popular");
    return PopularTvShows.fromJson(response.data);
  }

  // MOVIE DETAILS
  Future<MovieDetailScreenData> fetchMovieDetails(int movieId) async {
    final response = await _dio.get("/movie/$movieId");
    return MovieDetailScreenData.fromJson(response.data);
  }

  // RECOMMENDATIONS
  Future<MovieRecommendations> fetchMovieRecommendations(int movieId) async {
    final response = await _dio.get("/movie/$movieId/recommendations");
    return MovieRecommendations.fromJson(response.data);
  }

  // SEARCH
  Future<SearchMovies> fetchSearchMovies(String query) async {
    final response = await _dio.get(
      "/search/movie",
      queryParameters: {
        "query": query,
        "include_adult": false,
        "language": "en-US",
        "page": 1,
      },
    );
    return SearchMovies.fromJson(response.data);
  }
}
