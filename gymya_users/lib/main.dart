import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // No puedes usar rutas nombradas para pasar argumentos directamente
        // '/dashboard': (context) => DashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return DashboardScreen(
                token: args['token'],
                user: args['user'],
              );
            },
          );
        }
        return null;
      },
    );
  }
}