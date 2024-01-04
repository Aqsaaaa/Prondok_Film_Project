import 'dart:async';

import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:p9_basket_project/utils/favorite_dao.dart';
import 'package:p9_basket_project/utils/favorite.dart';

part 'database.g.dart';

@Database(version: 3, entities: [Favorite, Movie])
abstract class AppDatabase extends FloorDatabase {
  FavoriteDao get favoriteDao;
  MovieDao get movieDao;

  static final migration2to3 = Migration(2, 3, (database) async {
    await database.execute('CREATE TABLE IF NOT EXISTS `Movie` ('
        '`id` INTEGER PRIMARY KEY NOT NULL,'
        '`name` TEXT NOT NULL,'
        '`poster_path` TEXT NOT NULL,'
        '`adult` INTEGER NOT NULL,'
        '`popularity` REAL NOT NULL'
        ')');
  });
}
