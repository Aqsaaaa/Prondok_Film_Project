import 'package:floor/floor.dart';

import 'favorite.dart';

@dao
abstract class FavoriteDao {
  @Query('SELECT * FROM Favorite')
  Future<List<Favorite>> findAllPeople();

  @Query('SELECT * FROM Favorite WHERE id = :id')
  Future<Favorite?> findFavoriteById(int id);

  @insert
  Future<void> insertFavorite(Favorite favorite);

  @Query('DELETE FROM Favorite WHERE id = :id')
  Future<void> deleteFavoriteById(int id);
}
