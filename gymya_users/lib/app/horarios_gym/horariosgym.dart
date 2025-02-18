import 'package:flutter/material.dart';

class HorariosScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> user;

  const HorariosScreen({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo de la pantalla en negro
      appBar: AppBar(
        title: Text('Horarios', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Fondo del AppBar en negro
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Encabezado con nombre de sección y descripción
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.purple, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Horarios',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Consulta los horarios disponibles para tus entrenamientos.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 16),

              // Card de Horarios
              Card(
                color: Colors.grey[900], // Color de la tarjeta en gris oscuro
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Horarios Disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      // Aquí puedes agregar la lista de horarios
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