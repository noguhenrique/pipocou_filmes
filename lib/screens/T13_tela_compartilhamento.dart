import 'package:flutter/material.dart';

class CompartilhamentoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Compartilhamento',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [],
      ),
      //body: ,
    );
  }
}
