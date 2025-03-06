import 'package:flutter/material.dart';

class EntrenadoresCard extends StatefulWidget {
  final Map<String, dynamic> entrenador;

  const EntrenadoresCard({required this.entrenador});

  @override
  _EntrenadoresCardState createState() => _EntrenadoresCardState();
}

class _EntrenadoresCardState extends State<EntrenadoresCard> {
  @override
  Widget build(BuildContext context) {
    final entrenador = widget.entrenador;

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
              Row(
                children: [
                  // Imagen circular del entrenador
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(entrenador['imagenUrl']),
                  ),
                  SizedBox(width: 16),
                  // Nombre del entrenador
                  Text(
                    entrenador['nombre'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Mostrar otros datos del entrenador debajo
              Text(
                'Experiencia: ${entrenador['experiencia']} años',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Especialidad: ${entrenador['especialidad']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}