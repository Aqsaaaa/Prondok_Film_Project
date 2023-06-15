import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TVDetailScreen extends StatefulWidget {
  final int keywordId;
  final String accessToken;

  TVDetailScreen({required this.keywordId, required this.accessToken});

  @override
  _TVDetailScreenState createState() => _TVDetailScreenState();
}

class _TVDetailScreenState extends State<TVDetailScreen> {
  List<dynamic> tvShows = [];

  Future<void> fetchTVShowsByKeyword() async {
    String apiUrl = 'https://api.themoviedb.org/3/keyword/${widget.keywordId}/tv';

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
        // Gagal mengambil data dari API, lakukan penanganan kesalahan di sini
      }
    } catch (error) {
      // Terjadi kesalahan saat melakukan permintaan ke API, lakukan penanganan kesalahan di sini
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTVShowsByKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows by Keyword'),
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
