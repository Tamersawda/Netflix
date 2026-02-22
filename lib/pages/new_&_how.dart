import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:netflix_app/models/home/upcoming_movies.dart';
import 'package:netflix_app/pages/details/movie_detail_screen.dart';
import 'package:netflix_app/pages/search_page.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';

class NewHot extends StatefulWidget {
  const NewHot({super.key});

  @override
  State<NewHot> createState() => _NewHotState();
}

class _NewHotState extends State<NewHot> {
  final NetflixServices _netflixServices = NetflixServices();
  late Future<UpcomingMovies> _upcomingMoviesData;

  @override
  void initState() {
    super.initState();
    _upcomingMoviesData = _netflixServices.fetchUpcomingMovies();
  }

  String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '';
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('MMMM d, yyyy').format(date);
  } catch (e) {
    return dateString;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 1.1),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: Colors.black.withOpacity(0.1),
              elevation: 0,
              title: const Text(
                'New & Hot',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SearchPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.search_sharp,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<UpcomingMovies>(
        future: _upcomingMoviesData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading content',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
            return const Center(
              child: Text(
                'No upcoming movies',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final movies = snapshot.data!.results;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MovieDetailScreen(movieId: movie.id),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: Colors.grey.shade800),
                      color: Colors.black,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        movie.posterPath == null ||
                                movie.posterPath!.isEmpty
                            ? Container(
                                height: 320,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius:
                                      const BorderRadius.vertical(
                                    top: Radius.circular(14),
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 50,
                                  ),
                                ),
                              )
                            : ClipRRect(
                                borderRadius:
                                    const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '$IMAGE_URL${movie.posterPath}',
                                  height: 320,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formatDate(movie.releaseDate),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie.overview ?? '',
                                maxLines: 3,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton.icon(
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            6),
                                  ),
                                ),
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.black,
                                ),
                                label: const Text(
                                  'Remind Me',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
