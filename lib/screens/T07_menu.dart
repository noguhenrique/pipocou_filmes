import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black, // Define a cor do ícone como preto
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.black, // Define a cor do texto como preto
            ),
          ),
          backgroundColor:
              Colors.transparent, // Define o plano de fundo como transparente
          elevation: 0.0, // Remove a sombra padrão da AppBar
        ),
        body: ListView(
          children: [
            const Divider(
              color: Colors.black, // Define a cor da linha separadora
              thickness: 1.0, // Define a espessura da linha separadora
            ),
          ],
        ));
  }
}
