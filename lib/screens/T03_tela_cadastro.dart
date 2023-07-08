import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'T06_home.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = deviceWidth - 20 - 10;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logocomnome.png',
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _usernameController,
                        cursorColor: Colors.black,
                        validator: _usernameValidator,
                        decoration: InputDecoration(
                          hintText: 'Nome de usuário',
                          hintStyle: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                        controller: _emailController,
                        cursorColor: Colors.black,
                        validator: _emailValidator,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                          hintStyle: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
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
                      TextFormField(
                        controller: _confirmPasswordController,
                        cursorColor: Colors.black,
                        obscureText: !_isShowConfirmPassword,
                        validator: _confirmPasswordValidator,
                        decoration: InputDecoration(
                          hintText: 'Confirmar Senha',
                          hintStyle: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          suffixIcon: IconButton(
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _isShowConfirmPassword
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
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value!;
                              });
                            },
                            activeColor: Colors.black,
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                launch(
                                    'https://docs.google.com/document/d/e/2PACX-1vQGU6x4N3boEbyIziC0NBWofk2JlJa3BF1OIQTMYTfOic1tQaOHcivjQFgIZmY3lcHtyiUimfYldN2V/pub');
                              },
                              child: Text(
                                'Li e concordo com os Termos de Uso e Política de Privacidade',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: buttonWidth,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Registrar',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _usernameValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Forneça um nome de usuário válido';
    }

    return null;
  }

  String? _emailValidator(String? inputVal) {
    if (inputVal == null || inputVal.isEmpty) {
      return 'Forneça um email válido';
    }

    // Expressão regular para validar o formato do email
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (!emailRegex.hasMatch(inputVal)) {
      return 'Formato de email inválido';
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

  String? _confirmPasswordValidator(String? inputVal) {
    if (inputVal == null || inputVal.trim().isEmpty) {
      return 'Forneça uma senha válida';
    }

    final String password = _passwordController.text;

    if (inputVal.trim() != password) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Termos de Uso e Política de Privacidade'),
            content: Text(
                'Você precisa concordar com os Termos de Uso e Política de Privacidade para continuar.'),
            actions: [
              ElevatedButton(
                child: Text('OK'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String username = _usernameController.text.trim();
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      // Verifica se as senhas coincidem
      if (_confirmPasswordController.text != password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('As senhas não coincidem'),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Cria um usuário com email e senha no Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Armazena o nome de usuário no documento do usuário no Firestore
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'nome': username,
      });

      // Redireciona para a página inicial após o registro bem-sucedido
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro ao se cadastrar';

      if (e.code == 'weak-password') {
        errorMessage = 'A senha é muito fraca';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'O email já está em uso';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ocorreu um erro ao se cadastrar'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
