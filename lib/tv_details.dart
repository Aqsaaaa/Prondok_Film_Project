import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVDetailScreen extends StatefulWidget {
  final int genreId;
  final String accessToken;

  TVDetailScreen({required this.genreId, required this.accessToken});

  @override
  _TVDetailScreenState createState() => _TVDetailScreenState();
}

class _TVDetailScreenState extends State<TVDetailScreen> {
  List<dynamic> tvShows = [];

  Future<void> fetchTVShowsByGenre() async {
    String apiUrl =
        'https://api.themoviedb.org/3/discover/tv?with_genres=${widget.genreId}';

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

  @override
  void initState() {
    super.initState();
    fetchTVShowsByGenre();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows by Genre'),
      ),
      body: ListView.builder(
        itemCount: tvShows.length,
        itemBuilder: (context, index) {
          var tvShow = tvShows[index];
          return ListTile(
            title: Text(tvShow['name']),
            subtitle: Text('Vote Average: ${tvShow['vote_average'].toString()}'),
          );
        },
      ),
    );
  }
}
