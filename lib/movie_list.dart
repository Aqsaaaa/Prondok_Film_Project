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
  String genreName = '';

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

  Future<void> fetchGenreName() async {
    String apiUrl = 'https://api.themoviedb.org/3/genre/movie/list';

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
          var posterUrl =
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}';

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
    String apiUrl = 'https://api.themoviedb.org/3/movie/${widget.movieId}';

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
                      'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
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
