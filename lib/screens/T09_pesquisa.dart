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

  void navigateToFilmePage(dynamic movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilmePage(movie: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pipocou Filmes'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/conta');
            },
          ),
        ],
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
                                    movie['title'],
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
        selectedItemColor: Colors.amber,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(),
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
            icon: Icon(Icons.home, color: Colors.white),
            activeIcon: Icon(Icons.home, color: Colors.amber),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            activeIcon: Icon(Icons.search, color: Colors.amber),
            label: 'Pesquisa',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.white),
            activeIcon: Icon(Icons.favorite, color: Colors.amber),
            label: 'Wishlist',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play, color: Colors.white),
            activeIcon: Icon(Icons.playlist_play, color: Colors.amber),
            label: 'WatchedList',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
