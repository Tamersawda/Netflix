import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:netflix_app/models/details/tv_detail.dart';
import 'package:netflix_app/services/api_key.dart';
import 'package:netflix_app/services/netflix_service.dart';

class TvDetailScreen extends StatefulWidget {
  const TvDetailScreen({super.key, required this.tvId});
  final int tvId;

  @override
  State<TvDetailScreen> createState() => _TvDetailScreenState();
}

class _TvDetailScreenState extends State<TvDetailScreen> {
  final NetflixServices _services = NetflixServices();

  Future<TvDetailScreenData>? tvDetailData;
  Future<Map<String, dynamic>>? seasonData;

  int? selectedSeason;

  @override
  void initState() {
    super.initState();
    tvDetailData = _services.fetchTvDetails(widget.tvId);
  }

  void loadSeason(int seasonNumber) {
    setState(() {
      selectedSeason = seasonNumber;
      seasonData =
          _services.fetchSeasonDetails(widget.tvId, seasonNumber);
    });
  }

  Widget buildImage(String? path, String? fallback) {
    final imagePath = path ?? fallback;

    if (imagePath == null || imagePath.isEmpty) {
      return Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: '$IMAGE_URL$imagePath',
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade800,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<TvDetailScreenData>(
        future: tvDetailData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final tv = snapshot.data!;
          final height = MediaQuery.of(context).size.height;

          final seasons = tv.seasons
                  ?.where((s) => s.seasonNumber != 0)
                  .toList() ??
              [];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER IMAGE WITH STACK
                Container(
                  height: height * 0.35,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          child: buildImage(tv.posterPath, null)),

                      Positioned(
                        right: 15,
                        top: 50,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.cast,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                              border:
                                  Border.all(color: Colors.grey, width: 2),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
                      Text(
                        tv.originalName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// OVERVIEW
                      Text(
                        tv.overview ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 25),

                      /// SEASON DROPDOWN
                      if (seasons.isNotEmpty)
                        DropdownButton<int>(
                          dropdownColor: Colors.black,
                          value: selectedSeason,
                          hint: const Text(
                            "Select Season",
                            style: TextStyle(color: Colors.white),
                          ),
                          iconEnabledColor: Colors.white,
                          items: seasons
                              .map(
                                (season) => DropdownMenuItem<int>(
                                  value: season.seasonNumber,
                                  child: Text(
                                    season.name ?? '',
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              loadSeason(value);
                            }
                          },
                        ),

                      const SizedBox(height: 20),

                      /// EPISODES
                      if (seasonData != null)
                        FutureBuilder<Map<String, dynamic>>(
                          future: seasonData,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            final episodes =
                                snapshot.data!['episodes'] as List;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: episodes.length,
                              itemBuilder: (context, index) {
                                final ep = episodes[index];

                                return Container(
                                  margin:
                                      const EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        height: 70,
                                        child: buildImage(
                                          ep['still_path'],
                                          tv.posterPath,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${ep['episode_number']}. ${ep['name']}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              ep['overview'] ?? '',
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
