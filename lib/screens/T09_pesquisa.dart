import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T12_tela_filme.dart';

class PesquisaPage extends StatefulWidget {
  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  List<dynamic> searchResults = [];
  TextEditingController _searchController = TextEditingController();
  List<bool> isWishList = [];
  List<bool> isWatchedList = [];

  Future<void> searchMovies(String query) async {
    try {
      List<dynamic> fetchedMovies = await ApiConfig.searchMovies(query);
      setState(() {
        searchResults = fetchedMovies;
        isWishList = List.filled(fetchedMovies.length, false);
        isWatchedList = List.filled(fetchedMovies.length, false);
      });

      for (int i = 0; i < fetchedMovies.length; i++) {
        final movie = fetchedMovies[i];
        await checkWishlistStatus(movie, i);
        await checkWatchedListStatus(movie, i);
      }
    } catch (e) {
      print('Error searching movies: $e');
    }
  }

  void navigateToFilmePage(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilmePage(movie: movie),
      ),
    );
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      searchResults.clear();
      isWishList.clear();
      isWatchedList.clear();
    });
  }

  Future<void> checkWishlistStatus(dynamic movie, int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('wishlist')
            .doc(movie['id'].toString())
            .get();

        setState(() {
          isWishList[index] = snapshot.exists;
        });
      }
    } catch (e) {
      print('Error checking wishlist status: $e');
    }
  }

  Future<void> checkWatchedListStatus(dynamic movie, int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(movie['id'].toString())
            .get();

        setState(() {
          isWatchedList[index] = snapshot.exists;
        });
      }
    } catch (e) {
      print('Error checking watchedlist status: $e');
    }
  }

  void addToWishlist(dynamic movie, int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final filmeData = {
          'id': movie['id'],
          'nome': movie['title'],
          'ano': DateTime.parse(movie['release_date']).year,
          'urlPoster':
              'https://image.tmdb.org/t/p/original${movie['backdrop_path']}',
          'pontuacao': movie['vote_average'],
        };

        final isInWatchedList = await isMovieInWatchedList(movie);

        if (isInWatchedList) {
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
                    removeFromWatchedList(movie, index, false);

                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(user.uid)
                        .collection('wishlist')
                        .doc(movie['id'].toString())
                        .set(filmeData);

                    setState(() {
                      isWatchedList[index] = false;
                      isWishList[index] = true;
                    });

                    Navigator.of(context).pop();
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
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('wishlist')
              .doc(movie['id'].toString())
              .set(filmeData);

          setState(() {
            isWishList[index] = true;
          });
        }
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
    }
  }

  Future<bool> isMovieInWatchedList(dynamic movie) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(movie['id'].toString())
            .get();

        return snapshot.exists;
      }
    } catch (e) {
      print('Error checking watchedlist status: $e');
    }

    return false;
  }

  void addToWatchedList(dynamic movie, int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final filmeData = {
          'id': movie['id'],
          'nome': movie['title'],
          'ano': DateTime.parse(movie['release_date']).year,
          'urlPoster':
              'https://image.tmdb.org/t/p/original${movie['backdrop_path']}',
          'pontuacao': movie['vote_average'],
        };

        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('watchedlist')
            .doc(movie['id'].toString())
            .set(filmeData);

        removeFromWishlist(movie, index);

        setState(() {
          isWatchedList[index] = true;
        });
      }
    } catch (e) {
      print('Error adding to watchedlist: $e');
    }
  }

  void removeFromWishlist(dynamic movie, int index) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .collection('wishlist')
            .doc(movie['id'].toString())
            .delete();

        setState(() {
          isWishList[index] = false;
        });
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  void removeFromWatchedList(
      dynamic movie, int index, bool showConfirmationDialog) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (showConfirmationDialog) {
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
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(user.uid)
                        .collection('watchedlist')
                        .doc(movie['id'].toString())
                        .delete();

                    setState(() {
                      isWatchedList[index] = false;
                    });

                    Navigator.of(context).pop();
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
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.uid)
              .collection('watchedlist')
              .doc(movie['id'].toString())
              .delete();

          setState(() {
            isWatchedList[index] = false;
          });
        }
      }
    } catch (e) {
      print('Error removing from watchedlist: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/conta');
            },
          ),
        ],
        title: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/nometitulo.png',
            fit: BoxFit.contain,
            height: 80,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.transparent,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.black),
                    onPressed: clearSearch,
                  ),
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onSubmitted: searchMovies,
              ),
            ),
          ),
          if (searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  final movie = searchResults[index];
                  final movieTitle = movie['title'];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: InkWell(
                      onTap: () => navigateToFilmePage(movie),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 100,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
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
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    movieTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${movie['release_date'].substring(0, 4)}',
                                  ),
                                  SizedBox(height: 8),
                                  RatingBarIndicator(
                                    rating:
                                        movie['vote_average'].toDouble() / 2,
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isWishList[index]
                                              ? Icons.add_circle
                                              : Icons.add_circle_outline,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          if (isWishList[index]) {
                                            removeFromWishlist(movie, index);
                                          } else {
                                            addToWishlist(movie, index);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          isWatchedList[index]
                                              ? Icons.turned_in
                                              : Icons.turned_in_not,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          if (isWatchedList[index]) {
                                            removeFromWatchedList(
                                                movie, index, true);
                                          } else {
                                            addToWatchedList(movie, index);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          if (searchResults.isEmpty && _searchController.text.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Procure por um filme pelo título.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          if (searchResults.isEmpty && !_searchController.text.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Nenhum resultado encontrado.',
                style: TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
