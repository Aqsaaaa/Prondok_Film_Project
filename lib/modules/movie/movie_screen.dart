import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:p9_basket_project/utils/endpoint.dart';
import 'package:p9_basket_project/gen/colors.gen.dart';
import 'movie_list.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  List<dynamic> genres = [];
  int selectedGenreId = 0;

  Future<void> fetchGenres() async {
    String apiUrl = ApiEndPoint.kApiMovieGenres;
    String accessToken = kAccessToken;

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
      } else {}
    } catch (error) {}
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2),
            ),
            itemCount: genres.length,
            itemBuilder: (context, index) {
              var genre = genres[index];
              return GestureDetector(
                onTap: () {
                  selectGenre(genre['id']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieList(
                          genreId: selectedGenreId, accessToken: kAccessToken),
                    ),
                  );
                },
                child: Card(
                  color: ColorName.primary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: ColorName.secondary, width: 3.0),
                    borderRadius:
                        BorderRadius.circular(10.0), // Set your desired radius
                  ),
                  child: Center(
                    child: Text(genre['name'],
                        style: TextStyle(
                            fontSize: 16,
                            color: ColorName.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
