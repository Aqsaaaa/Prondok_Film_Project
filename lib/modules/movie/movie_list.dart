import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p9_basket_project/utils/dark_mode.dart';
import 'package:p9_basket_project/utils/endpoint.dart';
import 'package:p9_basket_project/modules/movie/movie_details.dart';
import 'package:provider/provider.dart';

import '../../gen/colors.gen.dart';
import '../../utils/database.dart';
import '../../utils/favorite.dart';

class MovieList extends StatefulWidget {
  final int genreId;
  final String accessToken;

  MovieList({required this.genreId, required this.accessToken});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Movie>> moviesFuture;
  List<dynamic> movies = [];
  String genreName = '';

  Future<void> fetchMoviesByGenre() async {
    String apiUrl =
        ApiEndPoint.kApiMovieDiscover + '?with_genres=${widget.genreId}';

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
          movies = data['results'] != null ? List.from(data['results']) : [];
        });
        print(data);
      } else {}
    } catch (error) {}
  }

  Future<void> _addAllFavorites(int index) async {
    if (index >= 0 && index < movies.length) {
      final database = await databaseFuture;
      final tvShow = movies[index];
      final id = tvShow['id'] ?? Random().nextInt(1000);
      final title = tvShow['title'] ?? 'Unknown Title';
      final posterPath = tvShow['poster_path'] ?? '';
      final isAdult = tvShow['adult'] ?? false;
      final popularity = tvShow['popularity'] ?? 0.0;

      final movie = Movie(
        id,
        title,
        'https://image.tmdb.org/t/p/w200$posterPath',
        isAdult,
        popularity,
      );

      await database.movieDao.insertMovie(movie);

      setState(() {
        moviesFuture = getMovies();
      });
    }
  }

  Future<bool> _isFavorite(int index) async {
    final database = await databaseFuture;
    final movie = movies[index];
    final id = movie['id'] ?? 0;
    final existingFavorite = await database.movieDao.findMovieById(id);
    return existingFavorite != null;
  }

  Future<List<Movie>> getMovies() async {
    final database = await databaseFuture;
    return database.movieDao.findAllPeople();
  }

  Future<void> fetchGenreName() async {
    String apiUrl = ApiEndPoint.kApiMovieGenres;

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

  void navigateToMovieDetails(dynamic movie) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You are viewing movie: ${movie['title']}'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsScreen(
          movieId: movie['id'],
          accessToken: widget.accessToken,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMoviesByGenre();
    fetchGenreName();
    databaseFuture = $FloorAppDatabase
        .databaseBuilder('favorites.db')
        .addMigrations([AppDatabase.migration2to3]).build();
    moviesFuture = getMovies();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
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
          actions: [
            IconButton(
              icon: Icon(themeState.darkTheme
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined),
              onPressed: () {
                setState(() {
                  themeState.setDarkTheme = !themeState.darkTheme;
                });
              },
            ),
          ],
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
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.05),
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            var movie = movies[index];
        
            return GestureDetector(
              onTap: () => navigateToMovieDetails(movie),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2),
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
                          'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    movie['title'].length > 25
                                        ? '${movie['title'].substring(0, 25)}...'
                                        : movie['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (await _isFavorite(index)) {
                                  final database = await databaseFuture;
                                  final movie = movies[index];
                                  final id = movie['id'] ?? 0;
                                  await database.movieDao.deleteMovieById(id);
        
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Removed from favorites'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  _addAllFavorites(index);
        
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Added to favorites'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                                setState(() {
                                  moviesFuture = getMovies();
                                });
                              },
                              icon: FutureBuilder<bool>(
                                future: _isFavorite(index),
                                builder: (context, snapshot) {
                                  if (snapshot.data == true) {
                                    return Icon(Icons.bookmark,
                                        color: Colors.yellow);
                                  } else {
                                    return Icon(Icons.bookmark_border);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Popularity',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                '${movie['popularity'].toString()}',
                                style: TextStyle(
                                  fontSize: 12,
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
                                ),
                              ),
                              Text(
                                movie['adult'] == null ? 'NO' : 'YES',
                                style: TextStyle(
                                  fontSize: 12,
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
                                ),
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
                                    movie['vote_average'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
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
    );
  }
}


// var movie = movies[index];
// var voteAverage = movie['vote_average'] ?? 0.0;
// var posterUrl = kApiImageBaseUrl + '${movie['poster_path']}';
