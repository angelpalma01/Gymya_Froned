import 'package:flutter/material.dart';

class HorariosScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const HorariosScreen({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios'),
      ),
      body: Center(
        child: Text('Pantalla de Horarios'),
      ),
    );
  }
}