import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../endpoint/endpoint.dart';

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
    String apiUrl = ApiEndPoint.kApiMovieDetails + '/${widget.movieId}';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization' : 'Bearer ${widget.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          movie = data;
        });
      } else {}
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  @override
  Widget build(BuildContext context) {
    if (movie == null) {
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    kApiImageBaseUrl + '${movie['poster_path']}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Vote Average',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 25,
                  ),
                  Text(
                    movie['vote_average'].toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Vote Count:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${movie['vote_count'].toString()}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  movie['overview'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                'Adult: ${movie['adult'] != null && movie['adult'] ? 'Yes' : 'No'}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Popularity: ${movie['popularity'].toString()}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
