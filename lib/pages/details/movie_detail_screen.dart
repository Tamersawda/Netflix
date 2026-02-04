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
    fetchMoviesData();
    super.initState();
  }

  void fetchMoviesData() {
    movieDetailData = _netflixApiServices.fetchMovieDetails(widget.movieId);
    movieRecommendations = _netflixApiServices.fetchMovieRecommendations(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder<MovieDetailScreenData>(
          future: movieDetailData,
          builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final movieData = snapshot.data!;
                  final size = MediaQuery.of(context).size.height;
            
                  String formatRuntime(int? runtime) {
                    if (runtime == null || runtime == 0) return '';
                    final h = runtime ~/ 60;
                    final m = runtime % 60;
                    return '${h}h ${m}m';
                  }
            
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size * 0.31,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              '$IMAGE_URL${movieData.posterPath}',
                            ),
                            fit: BoxFit.cover,
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
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: Icon(Icons.close, color: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  CircleAvatar(
                                    backgroundColor: Colors.black54,
                                    child: IconButton(
                                      icon: Icon(Icons.cast, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 120,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movieData.originalTitle ?? 'No Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  movieData.releaseDate?.year.toString() ??
                                      'No Release Date',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  formatRuntime(movieData.runtime),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'HD',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            DetailTopContainerButtons(),
                            SizedBox(height: 10),
                            Text(
                              movieData.genres?.join(' • ') ?? 'No Genres',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              movieData.overview ?? 'No Description Available',
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.add, color: Colors.white, size: 50),
                                    Text(
                                      'My List',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.thumb_up_off_alt,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    Text(
                                      'Rate',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.share_rounded,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            FutureBuilder(
                              future: movieRecommendations,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  final recommendationsData = snapshot.data!;
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      children: [
                                        if (recommendationsData.results.isNotEmpty)
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'More like this',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: recommendationsData.results.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 16,mainAxisSpacing: 16,childAspectRatio: 0.6,mainAxisExtent: 200),
                                          itemBuilder: (context, index) {
                                            final posterPath = recommendationsData.results[index].posterPath;
                                            if (posterPath == null) {
                                              return Container(
                                                color: Colors.grey[800],
                                                child: Center(
                                                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                                                ),
                                              );
                                            }
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: '$IMAGE_URL$posterPath',
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(color: Colors.white, fontSize: 36),
                    ),
                  );
                }
              },
            ),
        ),
      );
  }
}
