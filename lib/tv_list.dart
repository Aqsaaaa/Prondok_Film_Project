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

  void navigateToTVDetails(dynamic tvShow) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TVDetails(
          tvShow: tvShow,
        ),
      ),
    );
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
          return GestureDetector(
            onTap: () => navigateToTVDetails(tvShow),
            child: ListTile(
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
          );
        },
      ),
    );
  }
}

class TVDetails extends StatelessWidget {
  final dynamic tvShow;

  TVDetails({required this.tvShow});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tvShow['name']),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          SizedBox(height: 8),
          Text('Overview: ${tvShow['overview']}'),
          SizedBox(height: 8),
          Text('First Air Date: ${tvShow['first_air_date']}'),
        ],
      ),
    );
  }
}
