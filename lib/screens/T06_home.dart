import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pipocou_filmes/API/tmdb_api.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T09_pesquisa.dart';
import 'package:pipocou_filmes/screens/T10_whishlist.dart';
import 'package:pipocou_filmes/screens/T11_watchedlist.dart';
import 'package:pipocou_filmes/screens/T12_tela_filme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<dynamic> movies = [];

  final List<Widget> _pages = [
    PlaceholderWidget(text: 'Home'),
    PesquisaPage(),
    WishListPage(),
    WatchedListPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      List<dynamic> fetchedMovies = await ApiConfig.fetchMovies();
      setState(() {
        movies = fetchedMovies;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }
  
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
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FilmePage(movie: movie),
                ),
              );
            },
            child: GridTile(
              child: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Text(
                  movie['title'],
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),


      
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber, //cor da label da pagina atual
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon:
                Icon(Icons.home, color: Colors.white), // cor do ícone em espera
            activeIcon: Icon(Icons.home,
                color: Colors.amber), // cor do icone da pagina atual
            label: 'Home',
            backgroundColor: Colors.blue, // cor do fundo da pagina atual
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

class PlaceholderWidget extends StatelessWidget {
  final String text;

  PlaceholderWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
