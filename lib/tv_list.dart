import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVList extends StatefulWidget {
  final int genreId;
  final String accessToken;

  TVList({required this.genreId, required this.accessToken});

  @override
  _TVListState createState() => _TVListState();
}

class _TVListState extends State<TVList> {
  List<dynamic> tvShows = [];
  String genreName = '';

  Future<void> fetchTVShowsByGenre() async {
    String apiUrl = 'https://api.themoviedb.org/3/discover/tv?with_genres=${widget.genreId}';

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
      } else {
        // Handle API request error here
      }
    } catch (error) {
      // Handle error while making API request here
    }
  }

  Future<void> fetchGenreName() async {
    String apiUrl = 'https://api.themoviedb.org/3/genre/tv/list';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genreName TV Shows'),
      ),
      body: ListView.builder(
        itemCount: tvShows.length,
        itemBuilder: (context, index) {
          var tvShow = tvShows[index];
          var posterPath = tvShow['poster_path'] ?? '';

          return GestureDetector(
            onTap: () => navigateToTVDetails(tvShow),
            child: Column(
              children: [ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: posterPath.isNotEmpty
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w200$posterPath',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
                title: Text(tvShow['name']),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    SizedBox(width: 4),
                    Text(
                      tvShow['vote_average'].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

class TVDetailsScreen extends StatelessWidget {
  final dynamic tvShow;

  TVDetailsScreen({required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tvShow['name']),
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
                      'https://image.tmdb.org/t/p/w500${tvShow['poster_path']}',
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
                    tvShow['vote_average'].toString(),
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
                '${tvShow['vote_count'].toString()}',
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
                  tvShow['overview'],
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              
              Text(
                'Adult: ${tvShow['adult'] != null && tvShow['adult'] ? 'Yes' : 'No'}',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                'Popularity: ${tvShow['popularity'].toString()}',
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
