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

@dao
abstract class MovieDao {
  @Query('SELECT * FROM Movie')
  Future<List<Movie>> findAllPeople();

  @Query('SELECT * FROM Movie WHERE id = :id')
  Future<Movie?> findMovieById(int id);

  @insert
  Future<void> insertMovie(Movie movie);

  @Query('DELETE FROM Movie WHERE id = :id')
  Future<void> deleteMovieById(int id);
}
