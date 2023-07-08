import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class MenuPage extends StatelessWidget {
  final String _appVersion = "1.0.0";
  final String _appShareMessage =
      "Olha que aplicativo interessante, chama-se Pipocou Filmes! Baixe também em: https://play.google.com/store/apps/details?id=pipocoufilmes";

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareMessage(String message, {String? subject}) {
    Share.share(message, subject: subject);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Menu',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ListView(
        children: [
          Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Icon(
              Icons.notifications_active,
              size: 50,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notificações',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Receba notificações diárias do aplicativo.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Icon(
              Icons.movie_filter,
              size: 50,
            ),
            title: Text(
              'Pipocou Filmes',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    _launchURL(
                        'https://play.google.com/store/apps/details?id=pipocoufilmes');
                  },
                  child: Text(
                    'Avalie o app',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    _shareMessage(_appShareMessage);
                  },
                  child: Text(
                    'Compartilhe com amigos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    launch(
                        'https://docs.google.com/document/d/e/2PACX-1vQGU6x4N3boEbyIziC0NBWofk2JlJa3BF1OIQTMYTfOic1tQaOHcivjQFgIZmY3lcHtyiUimfYldN2V/pub');
                  },
                  child: Text(
                    'Termos de Uso e Política de Privacidade',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Versão $_appVersion',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 25),
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