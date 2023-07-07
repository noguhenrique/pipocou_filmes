import 'package:flutter/material.dart';
import 'package:pipocou_filmes/screens/T02_tela_login.dart';

class TrocaSenhaPage extends StatefulWidget {
  const TrocaSenhaPage({Key? key}) : super(key: key);

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
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logocomnome.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10),
            Text(
              'Verifique sua caixa de entrada de e-mail para encontrar o e-mail contendo o link de redefinição de senha.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Clicar no link fornecido redireciona para uma página da web onde a nova senha pode ser definida.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Após confirmar a alteração, você poderá fazer o login com a nova senha.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _toggleCheck,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _checkPressed ? Icons.check_box : Icons.check_box_outline_blank,
                      color: _checkPressed ? Colors.blue : Colors.grey,
                    ),
                    onPressed: _toggleCheck,
                  ),
                  const Text(
                    'Li as instruções',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _continuePressed,
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Continuar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
