import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  List<dynamic> comedyMovies = [];
  List<dynamic> actionMovies = [];
  List<dynamic> romanceMovies = [];
  List<dynamic> romanticComedyMovies = [];
  List<dynamic> dramaMovies = [];
  List<dynamic> suspenseMovies = [];
  List<dynamic> horrorMovies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final List<dynamic> fetchedMovies = await ApiConfig.fetchMovies();
      final List<dynamic> fetchedComedyMovies =
          await ApiConfig.fetchComedyMovies();
      final List<dynamic> fetchedActionMovies =
          await ApiConfig.fetchActionMovies();
      final List<dynamic> fetchedRomanceMovies =
          await ApiConfig.fetchRomanceMovies();
      final List<dynamic> fetchedRomanticComedyMovies =
          await ApiConfig.fetchRomanticComedyMovies();
      final List<dynamic> fetchedDramaMovies =
          await ApiConfig.fetchDramaMovies();
      final List<dynamic> fetchedSuspenseMovies =
          await ApiConfig.fetchSuspenseMovies();
      final List<dynamic> fetchedHorrorMovies =
          await ApiConfig.fetchHorrorMovies();

      setState(() {
        movies = fetchedMovies;
        comedyMovies = fetchedComedyMovies;
        actionMovies = fetchedActionMovies;
        romanceMovies = fetchedRomanceMovies;
        romanticComedyMovies = fetchedRomanticComedyMovies;
        dramaMovies = fetchedDramaMovies;
        suspenseMovies = fetchedSuspenseMovies;
        horrorMovies = fetchedHorrorMovies;
      });
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstMovie = movies.isNotEmpty ? movies.first : null;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (firstMovie != null) ...[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => FilmePage(movie: firstMovie)),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: SizedBox(
                    width: 200,
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
                                    'https://image.tmdb.org/t/p/original${firstMovie['backdrop_path']}',
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
                              '${firstMovie['title']} (${DateTime.parse(firstMovie['release_date']).year})',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            RatingBarIndicator(
                              rating: firstMovie['vote_average'].toDouble() / 2,
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
                ),
              ),
            ],
            if (movies.length > 1) ...[
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: const Text(
                  "Em alta",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    final movie = movies[index + 1];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => FilmePage(movie: movie)),
                        );
                      },
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(height: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
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
              const SizedBox(height: 15),
              MovieSection(
                title: 'Comédia',
                movies: comedyMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Ação',
                movies: actionMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Romance',
                movies: romanceMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Comédia Romântica',
                movies: romanticComedyMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Drama',
                movies: dramaMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Suspense',
                movies: suspenseMovies,
              ),
              const SizedBox(height: 15),
              MovieSection(
                title: 'Terror',
                movies: horrorMovies,
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 10, 63, 106),
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 0) {
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

class MovieSection extends StatelessWidget {
  final String title;
  final List<dynamic> movies;

  const MovieSection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (BuildContext context, int index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FilmePage(movie: movie)),
                  );
                },
                child: SizedBox(
                  width: 200,
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            movie['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
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
    );
  }
}
