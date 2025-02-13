import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true, // Evita que el teclado bloquee la pantalla
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          constraints: BoxConstraints(minHeight: screenHeight), // Permite scroll
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/Recursos/Img/Bienvenida.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.08),
              Container(
                height: screenHeight * 0.14,
                width: screenHeight * 0.14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('lib/Recursos/Img/Logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'GymYa',
                style: TextStyle(
                  fontSize: screenWidth * 0.09,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.12),
              AnimatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
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
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
        width: screenWidth * 0.6,
        constraints: const BoxConstraints(minWidth: 180, maxWidth: 350),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.07),
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
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
