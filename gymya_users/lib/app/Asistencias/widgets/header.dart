// widgets/header.dart
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08, // Ajusta el padding según el ancho
        vertical: 12.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [Colors.purple, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Historial de Asistencias',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.07, // Fuente ajustada al tamaño de pantalla
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}