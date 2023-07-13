import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'API/firebase_options.dart';
import 'package:pipocou_filmes/screens/T02_tela_login.dart';
import 'package:pipocou_filmes/screens/T03_tela_cadastro.dart';
import 'package:pipocou_filmes/screens/T04_tela_confirmacao_email.dart';
import 'package:pipocou_filmes/screens/T05_tela_troca_senha.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';
import 'package:pipocou_filmes/screens/T07_menu.dart';
import 'package:pipocou_filmes/screens/T08_conta.dart';
import 'package:pipocou_filmes/screens/T09_pesquisa.dart';
import 'package:pipocou_filmes/screens/T10_whishlist.dart';
import 'package:pipocou_filmes/screens/T11_watchedlist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseRemoteConfig.instance.fetchAndActivate();

  runApp(const PipocouFilmes());
}

class PipocouFilmes extends StatefulWidget {
  const PipocouFilmes({Key? key}) : super(key: key);

  @override
  _PipocouFilmesState createState() => _PipocouFilmesState();
}

class _PipocouFilmesState extends State<PipocouFilmes> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    PesquisaPage(),
    WishListPage(),
    WatchedListPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: Colors.grey.shade300,
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Color.fromARGB(255, 10, 63, 106),
          currentIndex: _currentIndex,
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
              activeIcon: Icon(Icons.add_circle,
                  color: Color.fromARGB(255, 8, 73, 126)),
              label: 'WishList',
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
          onTap: _onTabTapped,
        ),
      ),
      routes: {
        'pipocou':(context) => PipocouFilmes(),
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/confirmacao': (context) => ConfirmacaoEmailPage(),
        '/troca': (context) => TrocaSenhaPage(),
        '/menu': (context) => MenuPage(),
        '/conta': (context) => ContaPage(),
      },
    );
  }
}
