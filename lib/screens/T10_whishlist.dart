import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T09_pesquisa.dart';
import 'package:pipocou_filmes/screens/T11_watchedlist.dart';
import 'package:pipocou_filmes/screens/T12_tela_filme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WishListPage extends StatefulWidget {
  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  int _currentIndex = 2; // Defina o índice inicial para a tela de wishlist

  late User? _user;
  late CollectionReference _wishlistCollection;

  @override
  void initState() {
    super.initState();

    // Obter o usuário atualmente autenticado
    _user = FirebaseAuth.instance.currentUser;

    // Obter a referência para a subcoleção "wishlist" do usuário atual
    _wishlistCollection = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(_user?.uid)
        .collection('wishlist');
  }

  Future<Map<String, dynamic>?> fetchMovieDetails(String movieId) async {
    try {
      // Fazer a chamada à API para buscar as informações completas do filme
      final movieDetails = await ApiConfig.fetchMovieDetails(movieId);

      return movieDetails;
    } catch (e) {
      print('Error fetching movie details: $e');
      return null;
    }
  }

  Future<void> navigateToFilmePage(Map<String, dynamic> movieDetails) async {
    final updatedMovieDetails = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FilmePage(movie: movieDetails)),
    );

    // Verifica se o filme foi atualizado (por exemplo, se foi adicionado à lista de desejos)
    if (updatedMovieDetails != null) {
      // Atualiza a lista de desejos
      setState(() {
        // Atualize a lista de desejos conforme necessário
      });
    }
  }

  Future<bool> isMovieInWatchedList(String movieId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_user?.uid)
          .collection('watchedlist')
          .doc(movieId)
          .get();

      return snapshot.exists;
    } catch (e) {
      print('Error checking watchedlist status: $e');
      return false;
    }
  }

  void removeFromWishlist(String movieId) async {
    try {
      await _wishlistCollection.doc(movieId).delete();

      setState(() {
        // Atualize a lista de desejos conforme necessário
      });
    } catch (e) {
      print('Error removing from wishlist: $e');
    }
  }

  void addToWatchedList(Map<String, dynamic> movieDetails) async {
    try {
      final movieId = movieDetails['id'].toString();

      final filmeData = {
        'id': movieDetails['id'],
        'nome': movieDetails['title'],
        'ano': DateTime.parse(movieDetails['release_date']).year,
        'urlPoster':
            'https://image.tmdb.org/t/p/original${movieDetails['backdrop_path']}',
        'pontuacao': movieDetails['vote_average'],
      };

      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(_user?.uid)
          .collection('watchedlist')
          .doc(movieId)
          .set(filmeData);

      removeFromWishlist(movieId);

      setState(() {
        // Atualize a lista de desejos conforme necessário
      });
    } catch (e) {
      print('Error adding to watchedlist: $e');
    }
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
      body: FutureBuilder<QuerySnapshot>(
        future: _wishlistCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final List<QueryDocumentSnapshot> movies = snapshot.data!.docs;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index].data() as Map<String, dynamic>;
                final movieId = movie['id'].toString();

                return FutureBuilder<Map<String, dynamic>?>(
                  future: fetchMovieDetails(movieId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final movieDetails = snapshot.data!;
                      final movieTitle = movieDetails['title'];
                      bool isWish = true;
                      bool isWatched = false;

                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            navigateToFilmePage(movieDetails);
                          },
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
                                        'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 16,
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
                                        '${movieDetails['release_date'].substring(0, 4)}',
                                      ),
                                      SizedBox(height: 8),
                                      RatingBarIndicator(
                                        rating: movieDetails['vote_average']
                                                .toDouble() /
                                            2,
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              isWish
                                                  ? Icons.add_circle
                                                  : Icons.add_circle_outline,
                                              color:
                                                  isWish ? Colors.black : null,
                                            ),
                                            onPressed: () {
                                              if (isWish) {
                                                removeFromWishlist(movieId);
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isWatched
                                                  ? Icons.turned_in
                                                  : Icons.turned_in_not,
                                              color: isWatched
                                                  ? Colors.black
                                                  : null,
                                            ),
                                            onPressed: () {
                                              addToWatchedList(movieDetails);
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
                    } else {
                      return ListTile(
                        title: Text('Filme não encontrado'),
                        // ou exiba uma mensagem de erro adequada
                      );
                    }
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Sua lista de desejos está vazia, adicione filmes para assistir mais tarde!',
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 10, 63, 106),
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PesquisaPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WishListPage(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WatchedListPage(),
              ),
            );
          }

          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            activeIcon:
                Icon(Icons.home, color: Color.fromARGB(255, 8, 73, 126)),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black),
            activeIcon:
                Icon(Icons.search, color: Color.fromARGB(255, 8, 73, 126)),
            label: 'Pesquisa',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, color: Colors.black),
            activeIcon:
                Icon(Icons.add_circle, color: Color.fromARGB(255, 8, 73, 126)),
            label: 'Wishlist',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.turned_in_not, color: Colors.black),
            activeIcon:
                Icon(Icons.turned_in, color: Color.fromARGB(255, 8, 73, 126)),
            label: 'WatchedList',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
