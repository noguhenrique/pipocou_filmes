import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T13_tela_compartilhamento.dart';

class FilmePage extends StatefulWidget {
  final dynamic movie;

  const FilmePage({Key? key, required this.movie}) : super(key: key);

  @override
  _FilmePageState createState() => _FilmePageState();
}

class _FilmePageState extends State<FilmePage> {
  List<dynamic> movieCredits = [];
  bool isWish = false;
  bool isWatched = false;

  @override
  void initState() {
    super.initState();
    fetchMovieCredits();
    checkWishlistStatus();
    checkWatchedListStatus();
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

  Future<void> checkWishlistStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('wishlist')
            .doc(widget.movie['id'].toString())
            .get();

        setState(() {
          isWish = snapshot.exists;
        });
      }
    } catch (e) {
      print('Error checking wishlist status: $e');
    }
  }

  Future<void> checkWatchedListStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(widget.movie['id'].toString())
            .get();

        setState(() {
          isWatched = snapshot.exists;
        });
      }
    } catch (e) {
      print('Error checking watchedlist status: $e');
    }
  }

  void addToWishlist() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final filmeData = {
          'id': widget.movie['id'],
          'nome': widget.movie['title'],
          'ano': DateTime.parse(widget.movie['release_date']).year,
          'urlPoster':
              'https://image.tmdb.org/t/p/original${widget.movie['backdrop_path']}',
          'pontuacao': widget.movie['vote_average'],
        };

        final isInWatchedList =
            await isMovieInWatchedList(); // Verifica se o filme está na watchedlist

        if (isInWatchedList) {
          // Exibe a caixa de diálogo de confirmação
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Adicionar à Wishlist'),
              content: Text(
                  'Deseja remover o filme da Watchedlist e adicioná-lo à Wishlist?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Remove o filme da watchedlist
                    removeFromWatchedList(false);

                    // Adiciona o filme à wishlist
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(user.uid)
                        .collection('wishlist')
                        .doc(widget.movie['id'].toString())
                        .set(filmeData);

                    setState(() {
                      isWatched = false;
                      isWish = true;
                    });

                    Navigator.of(context).pop(); // Fecha a caixa de diálogo
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('Confirmar'),
                ),
              ],
            ),
          );
        } else {
          // Adiciona o filme à wishlist diretamente
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('wishlist')
              .doc(widget.movie['id'].toString())
              .set(filmeData);

          setState(() {
            isWish = true;
          });
        }
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<bool> isMovieInWatchedList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(widget.movie['id'].toString())
            .get();

        return snapshot.exists;
      }
    } catch (e) {
      print('Error checking watchedlist status: $e');
    }

    return false;
  }

  void addToWatchedList() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final filmeData = {
          'id': widget.movie['id'],
          'nome': widget.movie['title'],
          'ano': DateTime.parse(widget.movie['release_date']).year,
          'urlPoster':
              'https://image.tmdb.org/t/p/original${widget.movie['backdrop_path']}',
          'pontuacao': widget.movie['vote_average'],
        };

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(widget.movie['id'].toString())
            .set(filmeData);

        // Remove o filme da wishlist
        removeFromWishlist();

        setState(() {
          isWatched = true;
        });
      }
    } catch (e) {
      print('Error adding to watchedlist: $e');
    }
  }

  void removeFromWishlist() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('wishlist')
            .doc(widget.movie['id'].toString())
            .delete();

        setState(() {
          isWish = false;
        });
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  void removeFromWatchedList(bool showConfirmationDialog) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (showConfirmationDialog) {
          // Exibe uma caixa de diálogo de confirmação
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Remover da Watchedlist'),
              content: Text('Deseja remover o filme da Watchedlist?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Remove o filme da watchedlist
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(user.uid)
                        .collection('watchedlist')
                        .doc(widget.movie['id'].toString())
                        .delete();

                    setState(() {
                      isWatched = false;
                    });

                    Navigator.of(context).pop(); // Fecha a caixa de diálogo
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  child: Text('Remover'),
                ),
              ],
            ),
          );
        } else {
          // Remove o filme da watchedlist diretamente
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('watchedlist')
              .doc(widget.movie['id'].toString())
              .delete();

          setState(() {
            isWatched = false;
          });
        }
      }
    } catch (e) {
      print('Error removing from watchedlist: $e');
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
            Navigator.pop(context, true);
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CompartilhamentoPage(movie: widget.movie),
                ),
              );
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
                        '${widget.movie['title']} (${DateTime.parse(widget.movie['release_date']).year})',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isWish
                                    ? Icons.add_circle
                                    : Icons.add_circle_outline,
                                color: isWish ? Colors.black : null,
                              ),
                              onPressed: () {
                                if (isWish) {
                                  removeFromWishlist();
                                } else {
                                  addToWishlist();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                isWatched
                                    ? Icons.turned_in
                                    : Icons.turned_in_not,
                                color: isWatched ? Colors.black : null,
                              ),
                              onPressed: () {
                                if (isWatched) {
                                  removeFromWatchedList(true);
                                } else {
                                  addToWatchedList();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.movie['overview'] != null &&
                            widget.movie['overview'].isNotEmpty
                        ? widget.movie['overview']
                        : 'Sinopse não disponível.',
                  ),
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
                        final profilePath = actor['profile_path'];

                        if (profilePath != null) {
                          return Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500$profilePath',
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
                          );
                        } else {
                          return Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                child: const Icon(
                                  Icons.account_circle_outlined,
                                  size: 80, // Definindo o tamanho do ícone
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                actor['name'],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }
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

String formatDate(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}
