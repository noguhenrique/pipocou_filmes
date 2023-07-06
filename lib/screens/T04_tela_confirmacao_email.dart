import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pipocou_filmes/screens/T05_tela_troca_senha.dart';

class ConfirmacaoEmailPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TrocaSenhaPage()),
      );
    } catch (e) {
      // Trate aqui o erro ao enviar o e-mail de recuperação de senha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar e-mail de recuperação de senha.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email cadastrado',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String email = _emailController.text;
                _sendPasswordResetEmail(context, email);
              },
              child: Text('Recuperar'),
            ),
          ],
        ),
      ),
    );
  }
}
