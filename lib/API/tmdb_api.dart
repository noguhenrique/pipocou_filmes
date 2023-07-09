import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConfig {
  static const String apiKey = '135b94fe674451a4018e1262c8444c20';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String language = 'pt-BR';

  static Future<List<dynamic>> fetchMovies() async {
    final String url =
        '$baseUrl/movie/popular?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  static Future<List<dynamic>> fetchMovieGenres() async {
    final String url =
        '$baseUrl/genre/movie/list?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedGenres = data['genres'];
      return fetchedGenres;
    } else {
      throw Exception('Failed to fetch movie genres');
    }
  }

  static Future<List<dynamic>> searchMovies(String query) async {
    final String url =
        '$baseUrl/search/movie?api_key=$apiKey&language=$language&query=$query';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  static Future<List<dynamic>> fetchComedyMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=35';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch comedy movies');
    }
  }

  static Future<List<dynamic>> fetchActionMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=28';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch action movies');
    }
  }

  static Future<List<dynamic>> fetchRomanceMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=10749';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch romance movies');
    }
  }

  static Future<List<dynamic>> fetchDramaMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=18';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch drama movies');
    }
  }

  static Future<List<dynamic>> fetchSuspenseMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=9648';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch suspense movies');
    }
  }

  static Future<List<dynamic>> fetchHorrorMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=27';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch horror movies');
    }
  }

  static Future<List<dynamic>> fetchRomanticComedyMovies() async {
    final String url =
        '$baseUrl/discover/movie?api_key=$apiKey&language=$language&with_genres=10749,35';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch romantic comedy movies');
    }
  }

  static Future<List<dynamic>> fetchMovieCredits(int movieId) async {
    final String url =
        '$baseUrl/movie/$movieId/credits?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedCredits = data['cast'];
      return fetchedCredits;
    } else {
      throw Exception('Failed to fetch movie credits');
    }
  }

  static Future<Map<String, dynamic>?> fetchMovieDetails(String movieId) async {
    final String url =
        '$baseUrl/movie/$movieId?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

}
