import 'package:flutter/material.dart';
import 'package:p9_basket_project/utils/database.dart';

import '../../utils/favorite.dart';

class FavoriteMovieTv extends StatefulWidget {
  const FavoriteMovieTv({super.key});

  @override
  State<FavoriteMovieTv> createState() => _FavoriteMovieTvState();
}

class _FavoriteMovieTvState extends State<FavoriteMovieTv> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Favorite>> favoritesFuture;

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase.databaseBuilder('favorites.db').build();
    favoritesFuture = getFavorites();
  }

  Future<List<Favorite>> getFavorites() async {
    final database = await databaseFuture;
    return database.favoriteDao.findAllPeople();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([databaseFuture, favoritesFuture]),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var favorites = snapshot.data![1] as List<Favorite>;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          const SizedBox(height: 8),
                          Text('(${favorites[index].id.toString()})'),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w200${favorites[index].poster_path}',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Title  '),
                                  Text('Is Adult  '),
                                  Text('Popularity  '),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      ':  ${favorites[index].title.length > 10 ? '${favorites[index].title.substring(0, 10)}...' : favorites[index].title}'),
                                  Text(
                                      ':  ${favorites[index].adult ? 'Yes' : 'No'}'),
                                  Text(':  ${favorites[index].popularity}'),
                                ],
                              ),
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                final database = await $FloorAppDatabase
                                    .databaseBuilder('favorites.db')
                                    .build();
                                await database.favoriteDao
                                    .deleteFavoriteById(favorites[index].id);
                                setState(() {
                                  favorites.removeAt(index);
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete_outline_outlined),
                                  Text('Remove'),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
