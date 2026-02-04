import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/models/my_netflix/favorite_movies.dart';
import 'package:netflix_app/pages/details/movie_detail_screen.dart';
import 'package:netflix_app/pages/new_&_hot/search_page.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.accountId});
  final int accountId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final NetflixServices _netflixServices = NetflixServices();
  late Future<FavoriteMovies> favoriteMoviesData;

  @override
  void initState() {
    super.initState();
    favoriteMoviesData = _netflixServices.fetchFavoriteMovies(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'My Netflix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            icon: Icon(Icons.search),
            iconSize: 40,
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.list_rounded),
            iconSize: 40,
            color: Colors.white,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: SizedBox(
                height: 180,
                width: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/walp.jpg', fit: BoxFit.cover),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tamer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 5),
                Icon(Icons.expand_more_sharp, color: Colors.white, size: 38),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Your favorites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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

                        child: FutureBuilder(
                          future: favoriteMoviesData,
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
                              final movies = snapshot.data!.results;
                              return ListView.builder(
                                itemCount: movies.length > 10
                                    ? 10
                                    : movies.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final movie = movies[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: SizedBox(
                                      width: 160,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailScreen(
                                                    movieId: movie.id,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                child: Text(
                                  'Problem occured while fetching data',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
