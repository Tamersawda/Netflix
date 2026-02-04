import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/models/home/trending_movies.dart';
import 'package:netflix_app/models/search/search_movies.dart';
import 'package:netflix_app/pages/details/movie_detail_screen.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final NetflixServices _netflixServices = NetflixServices();
  late Future<TrendingMovies> trendingMoviesData;
  SearchMovies? searchMovies;
  void search(String query) {
    _netflixServices.fetchSearchMovies(query).then((results) {
      setState(() {
        searchMovies = results;
      });
    });
  }

  @override
  void initState() {
    trendingMoviesData = _netflixServices.fetchTrendingMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: CupertinoSearchTextField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            placeholder: 'Search shows & movies',
            placeholderStyle: TextStyle(color: Colors.white70, fontSize: 20),
            prefixIcon: Icon(Icons.search, color: Colors.white70,size: 30,),
            suffixIcon: Icon(Icons.clear, color: Colors.white),
            backgroundColor: Colors.grey.withOpacity(0.3),
            style: const TextStyle(color: Colors.white),
            onChanged: (value) {
              if (value.isEmpty) {
                setState(() => searchMovies = null);
              } else {
                search(value.trim());
              }
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _searchController.text.isEmpty
                ? FutureBuilder(
                    future: trendingMoviesData,
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
                        final trendingData = snapshot.data!.results;
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              if (trendingData.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 14),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Top Search',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ),
                                ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: trendingData.length,
                                itemBuilder: (context, index) {
                                  final topMovie = trendingData[index];
                                    return Stack( 
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 12, right: 5, top: 5, bottom: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                movieId: topMovie.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '$IMAGE_URL${topMovie.posterPath}',
                                              fit: BoxFit.cover,
                                              width: 150,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(fit: FlexFit.loose,
                                            child: Text(
                                              topMovie.title ?? 'asdfghxdcfghjkjnbhgvf',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )
                : searchMovies == null
                ? SizedBox.shrink()
                : ListView.builder(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchMovies?.results.length,
                    itemBuilder: (context, index) {
                      final search = searchMovies!.results[index];
                      return search.posterPath == null
                          ? SizedBox()
                          : Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                movieId: search.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                '$IMAGE_URL${search.posterPath}',
                                            fit: BoxFit.cover,
                                            width: 150,
                                          ),
                                          SizedBox(width: 20),
                                          Flexible(
                                            child: Text(
                                              search.title ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: Icon(
                                    Icons.play_circle_outline_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ],
                            );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
