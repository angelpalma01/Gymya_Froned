import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String userName;

  const Header({required this.userName, super.key});

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Envuelto en Flexible para que se ajuste en pantallas pequeñas
          Flexible(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                'Hola, $userName',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06, // Fuente ajustada al tamaño de pantalla
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Maneja textos largos en pantallas pequeñas
              ),
            ),
          ),
          // Ajuste dinámico del tamaño del avatar
          CircleAvatar(
            radius: screenWidth * 0.06, // Tamaño ajustable del avatar
            //backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
        ],
      ),
    );
  }
}