import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatefulWidget {
  final int keywordId;
  final String accessToken;

  MovieDetailScreen({required this.keywordId, required this.accessToken});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  List<dynamic> movies = [];

  Future<void> fetchMoviesByKeyword() async {
    String apiUrl = 'https://api.themoviedb.org/3/keyword/${widget.keywordId}/movies';

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
        // Gagal mengambil data dari API, lakukan penanganan kesalahan di sini
      }
    } catch (error) {
      // Terjadi kesalahan saat melakukan permintaan ke API, lakukan penanganan kesalahan di sini
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMoviesByKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies by Keyword'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          var movie = movies[index];
          return ListTile(
            title: Text(movie['title']),
            subtitle: Text('Vote Average: ${movie['vote_average'].toString()}'),
          );
        },
      ),
    );
  }
}
