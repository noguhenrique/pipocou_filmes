import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';

class FilmePage extends StatefulWidget {
  final dynamic movie;

  const FilmePage({Key? key, required this.movie}) : super(key: key);

  @override
  _FilmePageState createState() => _FilmePageState();
}

class _FilmePageState extends State<FilmePage> {
  List<dynamic> movieCredits = [];

  @override
  void initState() {
    super.initState();
    fetchMovieCredits();
  }

  Future<void> fetchMovieCredits() async {
    try {
      final List<dynamic> fetchedCredits =
          await ApiConfig.fetchMovieCredits(widget.movie['id']);
      setState(() {
        movieCredits = fetchedCredits;
      });
    } catch (e) {
      print('Error fetching movie credits: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            widget.movie['title'],
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/compartilhamento');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 350,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16),
                      Text(
                        'Data de lançamento: ${widget.movie['release_date']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Avaliação do público: ${widget.movie['vote_average'].toDouble()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Classificação indicativa: ${widget.movie['adult'] ? '18+' : 'Livre'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Duração: ${widget.movie['runtime'] != null ? '${widget.movie['runtime'].toString()} minutos' : 'N/A'}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      RatingBarIndicator(
                        rating: widget.movie['vote_average'].toDouble() / 2,
                        itemCount: 5,
                        itemSize: 20.0,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.movie['overview']),
                  SizedBox(height: 16),
                  const Text(
                    'Gênero',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<List<dynamic>>(
                    future: ApiConfig.fetchMovieGenres(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> movieGenres = snapshot.data!;
                        List genreNames = getGenreNames(
                            widget.movie['genre_ids'], movieGenres);
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: genreNames.map((genreName) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                genreName,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Failed to fetch movie genres');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Elenco',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieCredits.length,
                      itemBuilder: (context, index) {
                        final actor = movieCredits[index];
                        return Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500${actor['profile_path']}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                actor['name'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List getGenreNames(List<dynamic> genreIds, List<dynamic> genres) {
    return genreIds
        .map((id) => genres.firstWhere((genre) => genre['id'] == id)['name'])
        .toList();
  }
}
