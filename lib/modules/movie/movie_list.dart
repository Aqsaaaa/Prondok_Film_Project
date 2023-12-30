import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p9_basket_project/utils/endpoint.dart';
import 'package:p9_basket_project/modules/movie/movie_details.dart';

class MovieList extends StatefulWidget {
  final int genreId;
  final String accessToken;

  MovieList({required this.genreId, required this.accessToken});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genreName Movies'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index];
          var voteAverage = movie['vote_average'] ?? 0.0;
          var posterUrl = kApiImageBaseUrl + '${movie['poster_path']}';

          return GestureDetector(
            onTap: () => navigateToMovieDetails(movie),
            child: Column(
              children: [
                ListTile(
                  title: Text(movie['title']),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      SizedBox(width: 4),
                      Text(
                        voteAverage.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      posterUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 400,
                    ),
                  ),
                ),
                Divider(height: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}
