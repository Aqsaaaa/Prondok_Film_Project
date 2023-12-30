import 'dart:async';

import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:p9_basket_project/utils/favorite_dao.dart';
import 'package:p9_basket_project/utils/favorite.dart';

part 'database.g.dart';

@Database(version: 2, entities: [Favorite])
abstract class AppDatabase extends FloorDatabase {
  FavoriteDao get favoriteDao;
}
