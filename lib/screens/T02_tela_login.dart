import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T04_tela_confirmacao_email.dart';
import 'package:pipocou_filmes/screens/T05_tela_troca_senha.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ConfirmacaoEmailPage(),
                  ),
                );
              },
              child: Text('Esqueceu sua senha?'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TrocaSenhaPage(),
                  ),
                );
              },
              child: Text('Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}