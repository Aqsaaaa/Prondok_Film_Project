import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tv_list.dart';

class TvScreen extends StatefulWidget {
  @override
  _TvScreenState createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  List<dynamic> genres = [];
  int selectedGenreId = 0;

  Future<void> fetchGenres() async {
    String apiUrl = 'https://api.themoviedb.org/3/genre/tv/list';
    String accessToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZjc2OGJmYjgwNTU1MWVlZjhlZWY5Nzk1Yzg5YWIxOSIsInN1YiI6IjY0OGIwMjUwYzNjODkxMDE0ZWJjMTJhYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.H5rVMDOANbXjMZo5d7laATTvFQ3PElddG7M9f1YJRM4';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          genres = data['genres'] != null ? List.from(data['genres']) : [];
        });
      } else {
        // Handle API request error here
      }
    } catch (error) {
      // Handle error while making API request here
    }
  }

  void selectGenre(int genreId) {
    setState(() {
      selectedGenreId = genreId;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: genres.length,
              itemBuilder: (context, index) {
                var genre = genres[index];
                return ListTile(
                  title: Center(child: Text(genre['name'])),
                  tileColor: selectedGenreId == genre['id']
                      ? Colors.grey[300]
                      : Colors.white,
                  onTap: () {
                    selectGenre(genre['id']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TVList(
                          genreId: selectedGenreId,
                          accessToken:
                              'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZjc2OGJmYjgwNTU1MWVlZjhlZWY5Nzk1Yzg5YWIxOSIsInN1YiI6IjY0OGIwMjUwYzNjODkxMDE0ZWJjMTJhYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.H5rVMDOANbXjMZo5d7laATTvFQ3PElddG7M9f1YJRM4',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
