import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T09_pesquisa.dart';
import 'package:pipocou_filmes/screens/T10_whishlist.dart';

class WatchedListPage extends StatefulWidget {
  @override
  _WatchedListPageState createState() => _WatchedListPageState();
}

class _WatchedListPageState extends State<WatchedListPage> {
  int _currentIndex = 3; // Defina o índice inicial para a tela de watchedlist

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
      body: Center(
        child: Text('Conteúdo da página de watchedlist'),
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
            activeIcon: Icon(Icons.turned_in,
                color: Color.fromARGB(255, 8, 73, 126)),
            label: 'WatchedList',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
