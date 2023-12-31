import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'API/firebase_options.dart';

import 'package:pipocou_filmes/screens/T01_splash_screen.dart';
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

class PipocouFilmes extends StatelessWidget {
  const PipocouFilmes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: Colors
            .grey.shade300, // Definindo a cor da barra de digitação como preta
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/confirmacao': (context) => ConfirmacaoEmailPage(),
        '/troca': (context) => TrocaSenhaPage(),
        '/home': (context) => HomePage(),
        '/menu': (context) => MenuPage(),
        '/conta': (context) => ContaPage(),
        '/pesquisa': (context) => PesquisaPage(),
        '/whishlist': (context) => WishListPage(),
        '/watchedlist': (context) => WatchedListPage(),
      },
    );
  }
}


// indentar automático Shift+Alt+F