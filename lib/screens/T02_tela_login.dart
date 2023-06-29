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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                cursorColor: Colors.black,
                validator: _emailValidator,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                cursorColor: Colors.black,
                obscureText: true,
                validator: _passwordValidator,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.black54),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signIn,
                child: Text(
                  'Sign In',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : _forgotPassword,
                child: Text(
                  'Esqueceu sua senha',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : _navigateToCadastroPage,
                child: Text(
                  'Cadastre-se',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _emailValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Provide a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Provide a valid password';
    }

    if (inputVal.length < 8) {
      return 'Password must be at least 8 characters long';
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

      // Sign in user with Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Redirect to HomePage after successful login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred while signing in';

      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while signing in'),
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
