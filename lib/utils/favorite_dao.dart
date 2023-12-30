import 'package:floor/floor.dart';

import 'favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllPeople();
  
  @insert
  Future<void> insertFavorite(Favorite favorite);
  }