import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isPhone;

  const DetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isPhone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Ícono con gradiente
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.purple, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 16),
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto', // Cambia la tipografía si lo deseas
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isPhone && subtitle == 'No proporcionado'
                          ? Colors.grey
                          : Colors.white70,
                      fontSize: 16,
                      fontFamily: 'Roboto', // Cambia la tipografía si lo deseas
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}