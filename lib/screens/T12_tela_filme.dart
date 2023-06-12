import 'package:flutter/material.dart';

class FilmePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filme'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Navigator.pushNamed(context, '/compartilhamento');
            },
          ),
        ],
      ),
    );
  }
}