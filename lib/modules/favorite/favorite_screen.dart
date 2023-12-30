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
                    return ListTile(
                      leading: Text(favorites[index].id.toString()),
                      title: Text(favorites[index].title),
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
