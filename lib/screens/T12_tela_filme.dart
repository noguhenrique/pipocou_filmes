import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:hovering/hovering.dart';

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

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
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
            Navigator.pop(context);
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
            Container(
              padding: EdgeInsets.all(4),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/original${widget.movie['backdrop_path']}',
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 300,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.movie['title'],
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
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
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3),
                  Text(
                    'Avaliação do público: ${widget.movie['vote_average'].toDouble()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Data de lançamento: ${formatDate(DateTime.parse(widget.movie['release_date']))}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Classificação indicativa: ${widget.movie['adult'] ? '18+' : 'Livre'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
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
                        String genresText = '';

                        if (genreNames.length == 1) {
                          genresText = genreNames[0] + '.';
                        } else if (genreNames.length > 1) {
                          genresText = genreNames.join(', ') + '.';
                        }

                        return Text(
                          genresText,
                          style: TextStyle(
                            fontSize: 14,
                          ),
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
                        return HoverWidget(
                          child: Column(
                            children: [
                              Tooltip(
                                message: actor['name'],
                                child: Container(
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
                              ),
                              SizedBox(height: 4),
                              Opacity(
                                opacity: 0.0,
                                child: Text(
                                  actor['name'],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          hoverChild: Column(
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
                          onHover: (event) {},
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
