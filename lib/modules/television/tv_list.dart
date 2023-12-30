import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p9_basket_project/utils/database.dart';
import 'package:p9_basket_project/utils/endpoint.dart';
import 'package:p9_basket_project/gen/colors.gen.dart';
import 'package:p9_basket_project/utils/favorite.dart';

import 'tv_details.dart';

class TVList extends StatefulWidget {
  final int genreId;
  final String accessToken;

  TVList({required this.genreId, required this.accessToken});

  @override
  _TVListState createState() => _TVListState();
}

class _TVListState extends State<TVList> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Favorite>> favoritesFuture;

  List<dynamic> tvShows = [];
  String genreName = '';

  Future<void> fetchTVShowsByGenre() async {
    String apiUrl =
        ApiEndPoint.kApiTvDiscover + '?with_genres=${widget.genreId}';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          tvShows = data['results'] != null ? List.from(data['results']) : [];
        });
      } else {}
    } catch (error) {}
  }

  Future<void> _addAllFavorites(int index) async {
    if (index >= 0 && index < tvShows.length) {
      final database = await databaseFuture;
      final tvShow = tvShows[index];
      final id = tvShow['id'] ?? Random().nextInt(1000);
      final title = tvShow['name'] ?? 'Unknown Title';
      final posterPath = tvShow['poster_path'] ?? '';
      final isAdult = tvShow['adult'] ?? false;
      final popularity = tvShow['Popularity'] ?? 0.0;

      final favorite = Favorite(
        id,
        title,
        'https://image.tmdb.org/t/p/w200$posterPath',
        isAdult,
        popularity,
      );

      await database.favoriteDao.insertFavorite(favorite);

      setState(() {
        favoritesFuture = getFavorites();
      });
    }
  }

  Future<void> fetchGenreName() async {
    String apiUrl = ApiEndPoint.kApiTvGenres;

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var genres = data['genres'] != null ? List.from(data['genres']) : [];
        var genre = genres.firstWhere(
          (genre) => genre['id'] == widget.genreId,
          orElse: () => {},
        );
        setState(() {
          genreName = genre['name'] ?? '';
        });
      } else {}
    } catch (error) {}
  }

  Future<List<Favorite>> getFavorites() async {
    final database = await databaseFuture;
    return database.favoriteDao.findAllPeople();
  }

  void navigateToTVDetails(dynamic tvShow) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are viewing movie: ${tvShow['name']}'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TVDetailsScreen(
          tvShow: tvShow,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchTVShowsByGenre();
    fetchGenreName();
    databaseFuture = $FloorAppDatabase.databaseBuilder('favorites.db').build();
    favoritesFuture = getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: ColorName.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            '${genreName} TV Shows',
            style: TextStyle(
              fontSize: 20,
              color: ColorName.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.05),
            ),
            itemCount: tvShows.length,
            itemBuilder: (context, index) {
              var tvShow = tvShows[index];
              var posterPath = tvShow['poster_path'] ?? '';

              return GestureDetector(
                onTap: () => navigateToTVDetails(tvShow),
                child: Card(
                  color: ColorName.primary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorName.secondary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w200$posterPath',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Center(
                          child: Row(
                            children: [
                              Text(
                                tvShow['name'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: ColorName.white),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                  onPressed: () => _addAllFavorites(index),
                                  icon: Icon(Icons.bookmark_border))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Popularity',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorName.white),
                                ),
                                Text(
                                  '${tvShow['popularity'].toString()}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorName.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Adult',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorName.white),
                                ),
                                Text(
                                  tvShow['adult'] == null ? 'NO' : 'YES',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorName.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: ColorName.white),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: 12,
                                    ),
                                    Text(
                                      tvShow['vote_average'].toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: ColorName.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
