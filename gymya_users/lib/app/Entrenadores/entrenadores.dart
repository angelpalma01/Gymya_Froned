import 'package:flutter/material.dart';

class EntrenadoresScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const EntrenadoresScreen({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo de la pantalla en negro
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.purple, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            'Entrenadores',
            style: TextStyle(
              fontSize: 24, // Texto más grande
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black, // Fondo del AppBar en negro
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Padding a los lados
          child: Column(
            children: [
              SizedBox(height: 16), // Espacio superior
              // Texto de consulta
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0), // Padding sutil a los lados
                child: Text(
                  'Consulta la información de los entrenadores disponibles.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center, // Centrar el texto
                ),
              ),
              SizedBox(height: 16),

              // Card de Entrenadores
              Card(
                color: Colors.grey[900], // Color de la tarjeta en gris oscuro
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entrenadores Disponibles',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Aquí puedes agregar la lista de entrenadores
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
}