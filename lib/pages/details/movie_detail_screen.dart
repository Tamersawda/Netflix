import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/models/details/movie_recommendations.dart';
import 'package:netflix_app/models/details/movie_screen_data.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';
import 'package:netflix_app/utils/detail_top_container_buttons.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key, required this.movieId});
  final int movieId;

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final NetflixServices _netflixApiServices = NetflixServices();

  Future<MovieDetailScreenData>? movieDetailData;
  Future<MovieRecommendations>? movieRecommendations;

  @override
  void initState() {
    super.initState();
    fetchMoviesData();
  }

  void fetchMoviesData() {
    movieDetailData =
        _netflixApiServices.fetchMovieDetails(widget.movieId);
    movieRecommendations =
        _netflixApiServices.fetchMovieRecommendations(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetailScreenData>(
          future: movieDetailData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            final movieData = snapshot.data!;
            final size =
                MediaQuery.of(context).size.height;

            String formatRuntime(int? runtime) {
              if (runtime == null || runtime == 0)
                return '';
              final h = runtime ~/ 60;
              final m = runtime % 60;
              return '${h}h ${m}m';
            }

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  height: size * 0.31,
                  width: double.infinity,
                  decoration:
                      movieData.posterPath == null ||
                              movieData.posterPath!
                                  .isEmpty
                          ? BoxDecoration(
                              color: Colors
                                  .grey.shade800,
                            )
                          : BoxDecoration(
                              image:
                                  DecorationImage(
                                image:
                                    CachedNetworkImageProvider(
                                  '$IMAGE_URL${movieData.posterPath}',
                                ),
                                fit:
                                    BoxFit.cover,
                              ),
                            ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 15,
                        top: 50,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                    Icons.close,
                                    color:
                                        Colors.white),
                                onPressed: () {
                                  Navigator.pop(
                                      context);
                                },
                              ),
                            ),
                            const SizedBox(
                                width: 8),
                            const CircleAvatar(
                              backgroundColor:
                                  Colors.black54,
                              child: Icon(
                                  Icons.cast,
                                  color:
                                      Colors.white),
                            ),
                          ],
                        ),
                      ),

                      /// PLAY BUTTON (RESTORED)
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,
                              color:
                                  Colors.black54,
                              border:
                                  Border.all(
                                color:
                                    Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color:
                                  Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding:
                      const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        movieData.originalTitle ??
                            '',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            movieData
                                    .releaseDate
                                    ?.year
                                    .toString() ??
                                '',
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                              width: 10),
                          Text(
                            formatRuntime(
                                movieData
                                    .runtime),
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                              width: 5),
                          const Text(
                            'HD',
                            style:
                                TextStyle(
                              color:
                                  Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 10),
                      DetailTopContainerButtons(),

                      const SizedBox(
                          height: 20),

                      /// 3 ACTION ICONS
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceEvenly,
                        children: const [
                          Column(
                            children: [
                              Icon(Icons.add,
                                  color:
                                      Colors.white,
                                  size: 40),
                              SizedBox(height: 5),
                              Text('My List',
                                  style:
                                      TextStyle(
                                          color:
                                              Colors.white))
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons
                                      .thumb_up_off_alt,
                                  color:
                                      Colors.white,
                                  size: 40),
                              SizedBox(height: 5),
                              Text('Rate',
                                  style:
                                      TextStyle(
                                          color:
                                              Colors.white))
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons
                                      .share_rounded,
                                  color:
                                      Colors.white,
                                  size: 40),
                              SizedBox(height: 5),
                              Text('Share',
                                  style:
                                      TextStyle(
                                          color:
                                              Colors.white))
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(8),
                  child: Text(
                    movieData.overview ?? '',
                    style:
                        const TextStyle(
                            color:
                                Colors.white),
                  ),
                ),

                const SizedBox(height: 15),

                /// RECOMMENDATIONS GRID
                Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                              horizontal:
                                  8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Text(
                        'More Like This',
                        style:
                            TextStyle(
                          color:
                              Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<
                          MovieRecommendations>(
                        future:
                            movieRecommendations,
                        builder:
                            (context,
                                snapshot) {
                          if (!snapshot
                              .hasData) {
                            return const SizedBox
                                .shrink();
                          }

                          final movies =
                              snapshot
                                  .data!
                                  .results;

                          return GridView.builder(
                            shrinkWrap:
                                true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount:
                                movies.length >
                                        12
                                    ? 12
                                    : movies
                                        .length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  3,
                              crossAxisSpacing:
                                  10,
                              mainAxisSpacing:
                                  10,
                              childAspectRatio:
                                  0.6,
                            ),
                            itemBuilder:
                                (context,
                                    index) {
                              final poster =
                                  movies[index]
                                      .posterPath;

                              if (poster ==
                                  null) {
                                return Container(
                                  color: Colors
                                      .grey
                                      .shade800,
                                  child:
                                      const Icon(
                                    Icons
                                        .image_not_supported,
                                    color: Colors
                                        .grey,
                                  ),
                                );
                              }

                              return ClipRRect(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                child:
                                    CachedNetworkImage(
                                  imageUrl:
                                      '$IMAGE_URL$poster',
                                  fit:
                                      BoxFit
                                          .cover,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
