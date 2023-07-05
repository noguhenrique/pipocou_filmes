import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T02_tela_login.dart';

class TrocaSenhaPage extends StatefulWidget {
  const TrocaSenhaPage({super.key});

  @override
  _TrocaSenhaPageState createState() => _TrocaSenhaPageState();
}

class _TrocaSenhaPageState extends State<TrocaSenhaPage> {
  bool _checkPressed = false;

  void _toggleCheck() {
    setState(() {
      _checkPressed = !_checkPressed;
    });
  }

  void _continuePressed() {
    if (_checkPressed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Verifique sua caixa de entrada de e-mail para encontrar o e-mail contendo o link de redefinição de senha.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Clicar no link fornecido redireciona para uma página da web onde a nova senha pode ser definida.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'Após a confirmar a alteração, pode-se fazer o login com a nova senha.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Li as instruções',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    _checkPressed ? Icons.check_box : Icons.check_box_outline_blank,
                    color: _checkPressed ? Colors.blue : Colors.grey,
                  ),
                  onPressed: _toggleCheck,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _continuePressed,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
