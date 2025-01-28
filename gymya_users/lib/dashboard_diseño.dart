import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/'); // Redirige al login
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('¡Bienvenido al Dashboard!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción del botón
              },
              child: Text('Ver más información'),
            ),
          ],
        ),
      ),
    );
  }
}
