import 'package:flutter/material.dart';

class Gimnasioscard extends StatefulWidget {
  final Map<String, dynamic> gimnasio;

  const Gimnasioscard({required this.gimnasio});

  @override
  _GimnasioscardState createState() => _GimnasioscardState();
}

class _GimnasioscardState extends State<Gimnasioscard> {
  @override
  Widget build(BuildContext context) {
    final gimnasio = widget.gimnasio; // Referencia fácil al gimnasio

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen del gimnasio en la parte superior
              Center(
                child: Image.network(
                  gimnasio['imagen'] ?? 'https://via.placeholder.com/150',
                  width: double.infinity, // Ancho completo
                  height: 150, // Altura fija para hacerla rectangular
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16), // Espaciado entre la imagen y los datos

              // Nombre del gimnasio
              Text(
                gimnasio['nombre'] ?? 'Nombre no disponible',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Espaciado entre el nombre y la dirección

              // Dirección del gimnasio
              Text(
                gimnasio['direccion'] ?? 'Dirección no disponible',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8), // Espaciado entre la dirección y los otros datos

              // Usuarios dentro y horario en columnas separadas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Horario: ${gimnasio['horario'] ?? 'No disponible'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4), // Espaciado entre los textos
                  Text(
                    'Usuarios en el gimnasio: ${gimnasio['usuariosDentro'] ?? 0}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          // Funcionalidad al hacer tap, como navegar a otra página
        },
      ),
    );
  }
}