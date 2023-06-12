import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T05_tela_troca_senha.dart';

class ConfirmacaoEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => TrocaSenhaPage()),
            );
          },
          child: Text('Email Confirmado'),
        ),
      ),
    );
  }
}