import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T06_home.dart';

class TrocaSenhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: Text('Senha Trocada'),
        ),
      ),
    );
  }
}