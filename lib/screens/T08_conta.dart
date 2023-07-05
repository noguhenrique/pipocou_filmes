import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'T04_tela_confirmacao_email.dart';

class ContaPage extends StatefulWidget {
  @override
  _ContaPageState createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  Future<void> _showChangeEmailDialog() async {
    String? newEmail = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alteração de email'),
          content: TextFormField(
            decoration: InputDecoration(
              labelText: 'Novo email',
            ),
            onChanged: (value) {
              newEmail = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Continuar'),
              onPressed: () async {
                if (newEmail != null && newEmail!.isNotEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    try {
                      await user.updateEmail(newEmail!);
                      setState(() {
                        _userEmail = newEmail;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Email alterado com sucesso.'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao alterar o email.'),
                        ),
                      );
                    }
                  }
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangePasswordDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alteração de senha'),
          content: Text('Tem certeza de que deseja alterar a senha?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Continuar'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ConfirmacaoEmailPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAccountDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apagar conta'),
          content: Text('Tem certeza de que deseja apagar a conta? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Apagar'),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    await user.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Conta apagada com sucesso.'),
                      ),
                    );
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao apagar a conta.'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Tem certeza de que deseja fazer logout?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conta'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Bem vindo, $_userEmail',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.mail),
            title: Text('Alterar email'),
            onTap: () {
              _showChangeEmailDialog();
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Alterar senha'),
            onTap: () {
              _showChangePasswordDialog();
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text(
              'Apagar conta',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onTap: () {
              _confirmLogout();
            },
          ),
        ],
      ),
    );
  }
}
