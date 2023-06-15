import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieList extends StatefulWidget {
  final int genreId;
  final String accessToken;

  MovieList({required this.genreId, required this.accessToken});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  List<dynamic> movies = [];

  Future<void> fetchMoviesByGenre() async {
    String apiUrl =
        'https://api.themoviedb.org/3/discover/movie?with_genres=${widget.genreId}';

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
      } else {
        // Handle API request error here
      }
    } catch (error) {
      // Handle error while making API request here
    }
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
        builder: (context) => MovieDetails(movie: movie),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchMoviesByGenre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies by Genre'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index];
          return GestureDetector(
            onTap: () => navigateToMovieDetails(movie),
            child: ListTile(
              title: Text(movie['title']),
              subtitle: Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  SizedBox(width: 4),
                  Text(
                    movie['vote_average'].toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  final dynamic movie;

  MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              SizedBox(width: 4),
              Text(
                movie['vote_average'].toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text('Overview: ${movie['overview']}'),
          SizedBox(height: 8),
          Text('Release Date: ${movie['release_date']}'),
        ],
      ),
    );
  }
}
