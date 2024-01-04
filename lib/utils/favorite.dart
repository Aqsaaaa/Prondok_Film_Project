import 'package:floor/floor.dart';

@entity
class Favorite {
  @primaryKey
  final int id;
  final String title;
  final String poster_path;
  final bool adult;
  final double popularity;

  Favorite(
    this.id,
    this.title,
    this.poster_path,
    this.adult,
    this.popularity,
  );
}

@entity
class Movie {
  @primaryKey
  final int id;
  final String name;
  final String poster_path;
  final bool adult;
  final double popularity;

  Movie(
    this.id,
    this.name,
    this.poster_path,
    this.adult,
    this.popularity,
  );
}
