import 'package:flutter/material.dart';

class EntrenadoresScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const EntrenadoresScreen({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entrenadores'),
      ),
      body: Center(
        child: Text('Pantalla de Entrenadores'),
      ),
    );
  }
}