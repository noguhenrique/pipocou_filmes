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

  static Future<List<dynamic>> searchMovies(String query) async {
    final String url =
        '$baseUrl/search/movie?api_key=$apiKey&language=$language&query=$query';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];

      for (var movie in fetchedMovies) {
        final int id = movie['id'];
        final detailsUrl =
            '$baseUrl/movie/$id?api_key=$apiKey&language=$language';
        final detailsResponse = await http.get(Uri.parse(detailsUrl));
        if (detailsResponse.statusCode == 200) {
          final Map<String, dynamic> detailsData =
              json.decode(detailsResponse.body);
          final int runtime = detailsData['runtime'];
          movie['runtime'] = runtime;
        }
      }

      return fetchedMovies;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  static Future<List<dynamic>> fetchMovieGenres() async {
    final String url =
        '$baseUrl/genre/movie/list?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> genres = data['genres'];
      return genres;
    } else {
      throw Exception('Failed to fetch movie genres');
    }
  }
}
