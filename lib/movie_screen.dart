import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie_list.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<dynamic> genres = [];
  int selectedGenreId = 0;

  Future<void> fetchGenres() async {
    String apiUrl = 'https://api.themoviedb.org/3/genre/movie/list';
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
        // Gagal mengambil data dari API, lakukan penanganan kesalahan di sini
      }
    } catch (error) {
      // Terjadi kesalahan saat melakukan permintaan ke API, lakukan penanganan kesalahan di sini
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
      body: Center(
        child: ListView.builder(
          itemCount: genres.length,
          itemBuilder: (context, index) {
            var genre = genres[index];
            return ListTile(
              title: Center(child: Text(genre['name'])),
              onTap: () {
                selectGenre(genre['id']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieList(
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
    );
  }
}
