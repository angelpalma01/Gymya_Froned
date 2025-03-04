import 'package:flutter/material.dart';
import 'package:gymya_users/app/Perfil_usuario/perfil.dart'; // Asegúrate de que la ruta sea correcta

class Header extends StatelessWidget {
  final Map<String, dynamic> user;
  final String token;

  const Header({required this.user, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ancho de la pantalla
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08, // Ajusta el padding según el ancho
        vertical: 6.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Envuelto en Flexible para que se ajuste en pantallas pequeñas
          Flexible(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Text(
                'Hola, ${user['nombre_completo']}', // Accede al nombre del usuario
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.065, // Fuente ajustada al tamaño de pantalla
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis, // Maneja textos largos en pantallas pequeñas
              ),
            ),
          ),
          // Ajuste dinámico del tamaño del avatar
          GestureDetector(
            onTap: () {
              // Navegar a PerfilScreen al presionar el CircleAvatar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilScreen(
                    token: token,
                    user: user,
                    membresiaId: user['membresia_id'][0], // Pasa el ID de la membresía
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: screenWidth * 0.08,
              backgroundImage: NetworkImage(user['imagen']), // Accede a la imagen del usuario
            ),
          ),
        ],
      ),
    );
  }
}