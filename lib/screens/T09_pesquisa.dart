import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T10_whishlist.dart';
import 'package:pipocou_filmes/screens/T11_watchedlist.dart';
import 'package:pipocou_filmes/screens/T12_tela_filme.dart';

class PesquisaPage extends StatefulWidget {
  @override
  _PesquisaPageState createState() => _PesquisaPageState();
}

class _PesquisaPageState extends State<PesquisaPage> {
  int _currentIndex = 1;
  List<dynamic> searchResults = [];
  List<String> favorites = [];
  String? userID;

  Future<void> searchMovies(String query) async {
    try {
      List<dynamic> fetchedMovies = await ApiConfig.searchMovies(query);
      setState(() {
        searchResults = fetchedMovies;
      });
    } catch (e) {
      print('Error searching movies: $e');
    }
  }

Future<String?> getCurrentUserID() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    return null;
  }
}

  void toggleFavorite(String movieTitle) async {
    if (userID == null) {
      userID = await getCurrentUserID();
      if (userID == null) {
        // Lide com o caso em que o userID não pôde ser obtido
        return;
      }
    }

    setState(() {
      if (favorites.contains(movieTitle)) {
        favorites.remove(movieTitle);
        removeFavoriteFromFirebase(userID!, movieTitle);
      } else {
        favorites.add(movieTitle);
        addFavoriteToFirebase(userID!, movieTitle, 'Gênero do filme');
      }
    });
  }

  void addFavoriteToFirebase(String userID, String movieTitle, String movieGenre) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userID)
        .collection('userFavorites')
        .add({
          'title': movieTitle,
          'genre': movieGenre,
        });
  }

  void removeFavoriteFromFirebase(String userID, String movieTitle) {
    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(userID)
        .collection('userFavorites')
        .where('title', isEqualTo: movieTitle)
        .get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
  }

  void navigateToFilmePage(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilmePage(movie: movie),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchFavoritesFromFirebase();
  }

  void fetchFavoritesFromFirebase() async {
    userID = await getCurrentUserID();
    if (userID != null) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('usuarios').doc(userID).collection('userFavorites').get();

      List<String> fetchedFavorites = [];

      querySnapshot.docs.forEach((doc) {
        String title = doc.get('title');
        fetchedFavorites.add(title);
      });

      setState(() {
        favorites = fetchedFavorites;
      });
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
                  final isFavorite = favorites.contains(movieTitle);

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
                                  Text(
                                    movieTitle,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Ano de lançamento: ${movie['release_date'].substring(0, 4)}',
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Duração: ${movie['runtime'] != null ? '${movie['runtime']} minutos' : 'N/A'}',
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Classificação indicativa: ${movie['adult'] ? '18+' : 'Livre'}',
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
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      toggleFavorite(movieTitle);
                                    },
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
        ],
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
            icon: Icon(Icons.favorite, color: Colors.black),
            activeIcon:
                Icon(Icons.favorite, color: Color.fromARGB(255, 8, 73, 126)),
            label: 'Wishlist',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play, color: Colors.black),
            activeIcon: Icon(Icons.playlist_play,
                color: Color.fromARGB(255, 8, 73, 126)),
            label: 'WatchedList',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
