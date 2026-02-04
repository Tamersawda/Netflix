import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/models/home/movies_model.dart';
import 'package:netflix_app/models/home/popular_tv_shows.dart';
import 'package:netflix_app/models/home/top_ratedmovies.dart';
import 'package:netflix_app/models/home/trending_movies.dart';
import 'package:netflix_app/models/home/upcoming_movies.dart';
import 'package:netflix_app/pages/details/movie_detail_screen.dart';
import 'package:netflix_app/pages/new_&_hot/search_page.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';
import 'package:netflix_app/utils/top_categories.dart';
import 'package:netflix_app/utils/home_top_container_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NetflixServices _netflixServices = NetflixServices();
  late Future<Movies> movieData;
  late Future<UpcomingMovies> upcomingMovieData;
  late Future<TrendingMovies> trendingMovieData;
  late Future<TopRatedMovies> topRatedmoviesData;
  late Future<PopularTvShows> popularTvShowsData;

  @override
  void initState() {
    super.initState();
    movieData = _netflixServices.fetchMovies();
    upcomingMovieData = _netflixServices.fetchUpcomingMovies();
    trendingMovieData = _netflixServices.fetchTrendingMovies();
    topRatedmoviesData = _netflixServices.fetchTopRatedMovies();
    popularTvShowsData = _netflixServices.fetchPopularTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*1.5),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.1),
              elevation: 0,
              title: Text(
                'For Tamer',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ));
                    },
                   icon: Icon( Icons.search_sharp, size: 42, color: Colors.white)
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Category Buttons
            TopCategories(),
            // Large Container
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 510,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: FutureBuilder(
                      future: movieData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white),),
                          );
                        } else if (snapshot.hasData) {
                          final movies = snapshot.data!.results;
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PageView.builder(
                              itemCount: movies.length > 8 ? 8 : movies.length ,
                              itemBuilder: (context, index) {
                                final movie = movies[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => MovieDetailScreen(movieId: movie.id),
                                    ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          '$IMAGE_URL${movie.posterPath}',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Text('Problem occured while fetching data'),
                          );
                        }
                      },
                    ),
                  ),
                  TopContainerButtons(),
                  

                ],
              ),
            ),
            SizedBox(height: 10),
            // trending movies
            netflixData(future: trendingMovieData, text: 'Trending Movies'),
            SizedBox(height: 10),
            // Tv shows
            netflixData(future: popularTvShowsData, text: 'Popular Tv Series - Must-Watch For You'),
            SizedBox(height: 10),
            // trending movies
            netflixData(future: topRatedmoviesData, text: 'Top-Rated Movies'),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget netflixData<T>({required Future<T> future, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),

                child: FutureBuilder<T>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white),));
                    } else if (snapshot.hasData ) {
                      final movies = (snapshot.data as dynamic).results;
                      return ListView.builder(
                        itemCount: movies.length > 10 ? 10 :movies.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: SizedBox(
                              width: 160,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id),));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        '$IMAGE_URL${movie.posterPath}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('Problem occured while fetching data'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
