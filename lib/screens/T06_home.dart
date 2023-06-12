import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T09_pesquisa.dart';
import 'package:pipocou_filmes/screens/T10_whishlist.dart';
import 'package:pipocou_filmes/screens/T11_watchedlist.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PlaceholderWidget(text: 'Home'),
    PesquisaPage(),
    WishListPage(),
    WatchedListPage(),
  ];

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
      body: Center(
        child: Column(
          children: [
            _pages[_currentIndex],
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/filme');
              },
              child: Image.network(
                'https://media.filmelier.com/tit/RmUYwf/poster/seu-nome-gravado-em-mim_JKxoMN4.jpeg', // Insira a URL da imagem desejada
                width: 200,
                height: 200,
              ),
            ),
          ],
        ),
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
