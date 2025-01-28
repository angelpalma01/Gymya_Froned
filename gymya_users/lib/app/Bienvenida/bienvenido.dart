//Parte de bienevnida cuando se abre la app

import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Recursos/Img/Bienvenida.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la aplicación
            SizedBox(height: screenHeight * 0.090),
            Container(
              height: screenHeight * 0.15,
              width: screenHeight * 0.15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('lib/Recursos/Img/Logo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Título "GymYa"
            Text(
              'GymYa',
              style: TextStyle(
                fontSize: screenWidth * 0.10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: screenHeight * 0.14),
            // Botón "Iniciar sesión"
            AnimatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navegar al login
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedButton({super.key, required this.onPressed});

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
        width: screenWidth * 0.7,
        constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          gradient: LinearGradient(
            colors: _isPressed
                ? [const Color(0xFFB20E42), const Color(0xFF7E1ADB)]
                : [const Color(0xFF7E1ADB), const Color(0xFFB20E42)],
          ),
        ),
        child: Center(
          child: Text(
            'Iniciar sesión',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
