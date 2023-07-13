import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'T04_tela_confirmacao_email.dart';

class ContaPage extends StatefulWidget {
  @override
  _ContaPageState createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  String? _userEmail;
  String? _userName;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkUserLogin();
    _loadUserData();
  }

  Future<void> _checkUserLogin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        setState(() {
          _userEmail = user.email;
          _userName = snapshot.get('nome');
          _nameController.text = _userName ?? '';
        });
      }
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
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onChanged: (value) {
              newEmail = value;
            },
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Continuar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
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
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Continuar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ConfirmacaoEmailPage()),
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
          content: Text(
              'Tem certeza de que deseja apagar a conta? Esta ação não pode ser desfeita.'),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Apagar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  String userId = user.uid;

                  // Criar uma transação em lote para excluir os documentos das subcoleções
                WriteBatch batch = FirebaseFirestore.instance.batch();
                CollectionReference wishlistCollection = FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(userId)
                    .collection('wishlist');
                CollectionReference watchedListCollection = FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(userId)
                    .collection('watchedlist');

                // Excluir todos os documentos da subcoleção "wishlist"
                QuerySnapshot wishlistSnapshot = await wishlistCollection.get();
                for (DocumentSnapshot doc in wishlistSnapshot.docs) {
                  batch.delete(doc.reference);
                }

                // Excluir todos os documentos da subcoleção "watchedlist"
                QuerySnapshot watchedListSnapshot = await watchedListCollection.get();
                for (DocumentSnapshot doc in watchedListSnapshot.docs) {
                  batch.delete(doc.reference);
                }

                // Executar a transação em lote para excluir os documentos das subcoleções
                await batch.commit();

                // Excluir o documento "usuarios" do usuário no Cloud Firestore
                await FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(userId)
                    .delete();

                  try {
                    // Apagar a conta do usuário
                    await user.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Conta apagada com sucesso.'),
                      ),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/pipocou', (route) => false);
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
          title: Text('Sair'),
          content: Text('Tem certeza de que deseja sair?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Sair'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
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
    Navigator.pushNamedAndRemoveUntil(context, '/pipocou', (route) => false);
  }

  Future<void> _showChangeNameDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alterar nome'),
          content: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Novo nome',
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Salvar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              onPressed: () async {
                String newName = _nameController.text.trim();
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  try {
                    String userId = user.uid;
                    await FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(userId)
                        .update({
                      'nome': newName,
                    });
                    setState(() {
                      _userName = newName;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nome alterado com sucesso.'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao alterar o nome.'),
                      ),
                    );
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
          'Conta',
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
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
                ), // Ajuste o valor de horizontal para mover o ícone
            leading: Icon(
              Icons.account_circle,
              size: 50,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Alinhar o texto à esquerda
              children: [
                Text(
                  '$_userName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$_userEmail',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
          const Divider(
            thickness: 1,
            color: Colors.black,
          ),
          const ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8), // Ajuste o valor de horizontal para mover o ícone
            leading: Icon(
              Icons.manage_accounts,
              size: 50,
            ),
            title: Text(
              'Configurações:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            dense: true,
            visualDensity: VisualDensity.compact,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Alterar nome'),
                  onTap: () {
                    _showChangeNameDialog();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text('Alterar email'),
                  onTap: () {
                    _showChangeEmailDialog();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Alterar senha'),
                  onTap: () {
                    _showChangePasswordDialog();
                  },
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
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    'Sair',
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
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
