import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  final String accessToken;

  MovieDetailsScreen({required this.movieId, required this.accessToken});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  dynamic movie;

  Future<void> fetchMovieDetails() async {
    String apiUrl =
        'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=${widget.accessToken}';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          movie = data;
        });
      } else {
        // Handle API request error here
      }
    } catch (error) {
      // Handle error while making API request here
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
      // Render loading indicator or placeholder while fetching movie details
      return Scaffold(
        appBar: AppBar(
          title: Text('Movie Details'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            movie['poster_path'] != null
                ? Image.network(
                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    width: 200,
                    height: 400,
                    fit: BoxFit.cover,
                  )
                : Placeholder(
                    fallbackHeight: 400,
                    fallbackWidth: 200,
                  ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(width: 8),
                Text('Vote Count: ${movie['vote_count']}'),
              ],
            ),
            SizedBox(height: 8),
            Text('Title: ${movie['title']}'),
            SizedBox(height: 8),
            Text('Adult: ${movie['adult']}'),
            SizedBox(height: 8),
            Text('Popularity: ${movie['popularity']}'),
          ],
        ),
      ),
    );
  }
}
