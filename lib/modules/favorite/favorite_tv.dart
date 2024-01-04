import 'package:flutter/material.dart';
import 'package:p9_basket_project/utils/dark_mode.dart';
import 'package:p9_basket_project/utils/database.dart';
import 'package:provider/provider.dart';

import '../../gen/colors.gen.dart';
import '../../utils/favorite.dart';

class FavoriteMovieTv extends StatefulWidget {
  const FavoriteMovieTv({super.key});

  @override
  State<FavoriteMovieTv> createState() => _FavoriteMovieTvState();
}

class _FavoriteMovieTvState extends State<FavoriteMovieTv> {
  late Future<AppDatabase> databaseFuture;
  late Future<List<Favorite>> favoritesFuture;
  late Future<List<Movie>> moviesFuture;

  @override
  void initState() {
    super.initState();
    databaseFuture = $FloorAppDatabase.databaseBuilder('favorites.db').build();
    favoritesFuture = getFavorites();
    moviesFuture = getMovies();
  }

  Future<List<Favorite>> getFavorites() async {
    final database = await databaseFuture;
    return database.favoriteDao.findAllPeople();
  }

  Future<List<Movie>> getMovies() async {
    final database = await databaseFuture;
    return database.movieDao.findAllPeople();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'TV Shows'),
                Tab(text: 'Movies'),
              ],
            ),
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: ColorName.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(themeState.darkTheme
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined),
                onPressed: () {
                  setState(() {
                    themeState.setDarkTheme = !themeState.darkTheme;
                  });
                },
              ),
            ],
            centerTitle: true,
            title: Text(
              'Favorites',
              style: TextStyle(
                fontSize: 20,
                color: ColorName.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: Future.wait([databaseFuture, favoritesFuture]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
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
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                          '(${favorites[index].id.toString()})'),
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w200${favorites[index].poster_path}',
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Title  '),
                                              Text('Is Adult  '),
                                              Text('Popularity  '),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ':  ${favorites[index].title.length > 10 ? '${favorites[index].title.substring(0, 10)}...' : favorites[index].title}'),
                                              Text(
                                                  ':  ${favorites[index].adult ? 'Yes' : 'No'}'),
                                              Text(
                                                  ':  ${favorites[index].popularity}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final database =
                                                await $FloorAppDatabase
                                                    .databaseBuilder(
                                                        'favorites.db')
                                                    .build();
                                            await database.favoriteDao
                                                .deleteFavoriteById(
                                                    favorites[index].id);
                                            setState(() {
                                              favorites.removeAt(index);
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons
                                                  .delete_outline_outlined),
                                              Text('Remove'),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            minimumSize:
                                                Size(double.infinity, 50),
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
            ),
            FutureBuilder(
              future: Future.wait([databaseFuture, moviesFuture]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  print('${snapshot.data![1]}');
                  var movie = snapshot.data![1] as List<Movie>;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: movie.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text('(${movie[index].id.toString()})'),
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w200${movie[index].poster_path}',
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Title  '),
                                              Text('Is Adult  '),
                                              Text('Popularity  '),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ':  ${movie[index].name.length > 10 ? '${movie[index].name.substring(0, 10)}...' : movie[index].name}'),
                                              Text(
                                                  ':  ${movie[index].adult ? 'Yes' : 'No'}'),
                                              Text(
                                                  ':  ${movie[index].popularity}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final database =
                                                await $FloorAppDatabase
                                                    .databaseBuilder(
                                                        'favorites.db')
                                                    .build();
                                            await database.movieDao
                                                .deleteMovieById(
                                                    movie[index].id);
                                            setState(() {
                                              movie.removeAt(index);
                                            });
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons
                                                  .delete_outline_outlined),
                                              Text('Remove'),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            minimumSize:
                                                Size(double.infinity, 50),
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
            ),
          ],
        ),
      ),
    );
  }
}



// FutureBuilder(
//       future: Future.wait([databaseFuture, favoritesFuture]),
//       builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done &&
//             snapshot.hasData) {
//           var favorites = snapshot.data![1] as List<Favorite>;
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: favorites.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.blueAccent),
//                           borderRadius: BorderRadius.circular(4.0),
//                         ),
//                         child:
//                             Column(mainAxisSize: MainAxisSize.min, children: [
//                           const SizedBox(height: 8),
//                           Text('(${favorites[index].id.toString()})'),
//                           Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(
//                                   'https://image.tmdb.org/t/p/w200${favorites[index].poster_path}',
//                                   width: 150,
//                                   height: 150,
//                                   fit: BoxFit.contain,
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Title  '),
//                                   Text('Is Adult  '),
//                                   Text('Popularity  '),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                       ':  ${favorites[index].title.length > 10 ? '${favorites[index].title.substring(0, 10)}...' : favorites[index].title}'),
//                                   Text(
//                                       ':  ${favorites[index].adult ? 'Yes' : 'No'}'),
//                                   Text(':  ${favorites[index].popularity}'),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           Center(
//                             child: ElevatedButton(
//                               onPressed: () async {
//                                 final database = await $FloorAppDatabase
//                                     .databaseBuilder('favorites.db')
//                                     .build();
//                                 await database.favoriteDao
//                                     .deleteFavoriteById(favorites[index].id);
//                                 setState(() {
//                                   favorites.removeAt(index);
//                                 });
//                               },
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(Icons.delete_outline_outlined),
//                                   Text('Remove'),
//                                 ],
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 minimumSize: Size(double.infinity, 50),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                         ]),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         } else {
//           return const CircularProgressIndicator();
//         }
//       },
//     );