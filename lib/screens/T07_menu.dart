import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Container(
          child: Text(FirebaseRemoteConfig.instance.getString('api_token')))
      ),
    );
  }
}