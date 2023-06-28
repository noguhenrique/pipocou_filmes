import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConfig {
  static const String apiKey = '135b94fe674451a4018e1262c8444c20';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String language = 'pt-BR'; // Defina o idioma para português do Brasil

  static Future<List<dynamic>> fetchMovies() async {
    final String url = '$baseUrl/movie/popular?api_key=$apiKey&language=$language';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> fetchedMovies = data['results'];
      return fetchedMovies;
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}
