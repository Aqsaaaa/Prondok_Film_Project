const kBaseUrl = 'https://api.themoviedb.org/3';
const kApiImageBaseUrl = 'https://image.tmdb.org/t/p/w500';

const kAccessToken =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmZjc2OGJmYjgwNTU1MWVlZjhlZWY5Nzk1Yzg5YWIxOSIsInN1YiI6IjY0OGIwMjUwYzNjODkxMDE0ZWJjMTJhYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.H5rVMDOANbXjMZo5d7laATTvFQ3PElddG7M9f1YJRM4';

class ApiEndPoint {
  static const kApiMovieDetails = '$kBaseUrl/movie';
  static const kApiMovieGenres = '$kBaseUrl/genre/movie/list';
  static const kApiMovieDiscover = '$kBaseUrl/discover/movie';

  static const kApiTvDetails = '$kBaseUrl/tv';
  static const kApiTvGenres = '$kBaseUrl/genre/tv/list';
  static const kApiTvDiscover = '$kBaseUrl/discover/tv';

}
