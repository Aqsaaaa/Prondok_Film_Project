import 'package:flutter/material.dart';
import 'package:p9_basket_project/utils/endpoint.dart';

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
                    kApiImageBaseUrl + '${tvShow['poster_path']}',
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
