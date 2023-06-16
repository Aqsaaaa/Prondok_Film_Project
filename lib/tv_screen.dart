import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tv_list.dart';

class TvScreen extends StatefulWidget {
  @override
  _TvScreenState createState() => _TvScreenState();
}

class _TvScreenState extends State<TvScreen> {
  List<dynamic> tvShows = [];

  Future<void> fetchTvShows() async {
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
          tvShows = data['genres'] != null ? List.from(data['genres']) : [];
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
    fetchTvShows();
  }

  void navigateToTvShowList(int genreId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TVList(
          genreId: genreId,
          accessToken:
              'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZjc2OGJmYjgwNTU1MWVlZjhlZWY5Nzk1Yzg5YWIxOSIsInN1YiI6IjY0OGIwMjUwYzNjODkxMDE0ZWJjMTJhYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.H5rVMDOANbXjMZo5d7laATTvFQ3PElddG7M9f1YJRM4',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('TV Shows'),
      // ),
      body: ListView.builder(
        itemCount: tvShows.length,
        itemBuilder: (context, index) {
          var tvShow = tvShows[index];
          return ListTile(
            title: Text(tvShow['name']),
            onTap: () => navigateToTvShowList(tvShow['id']),
          );
        },
      ),
    );
  }
}
