import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'T04_tela_confirmacao_email.dart';
import 'T03_tela_cadastro.dart';
import 'T06_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isShowPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = deviceWidth - 20 - 10;

    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Impede o overflow quando o teclado é aberto
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Permite rolagem do conteúdo quando necessário
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/logocomnome.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  validator: _emailValidator,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: Colors.black,
                  obscureText: !_isShowPassword,
                  validator: _passwordValidator,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.black54),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    suffixIcon: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          _isShowPassword = !_isShowPassword;
                        });
                      },
                      icon: Icon(
                        _isShowPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: buttonWidth,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Entrar',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom:
                                  15), // Adicionando espaçamento inferior de 50 pixels
                          child: TextButton(
                            onPressed: _isLoading ? null : _forgotPassword,
                            child: Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: deviceWidth,
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _isLoading ? null : _navigateToCadastroPage,
                        child: Text(
                          'Cadastre-se',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Divider(
                          color: Colors.black,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Forneça um email válido';
    }
    return null;
  }

  String? _passwordValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Forneça uma senha válida';
    }

    if (inputVal.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }

    return null;
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Fazer login do usuário com o Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Redirecionar para a página inicial após o login bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro ao fazer login';

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Email ou senha inválidos';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao fazer login'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _forgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ConfirmacaoEmailPage(),
      ),
    );
  }

  void _navigateToCadastroPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CadastroPage(),
      ),
    );
  }
}
