import 'package:flutter/material.dart';
import 'app/Bienvenida/bienvenido.dart';
import './app/Inicio_sesion/login_screen.dart';
import 'app/Home/home.dart' as ds_screen;
import './dashboard_diseño.dart' as ds_diseno;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gymya',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Oculta el banner "DEBUG"
      initialRoute: '/bienvenida', // Pantalla inicial
      routes: {
        '/bienvenida': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return ds_screen.DashboardScreen(
                token: args['token'],
                user: args['user'],
                membresiaId: args['membresia_id'],
              );
            },
          );
        }
        if (settings.name == '/dashboard_diseno') {
          return MaterialPageRoute(
            builder: (context) {
              return ds_diseno.DashboardScreen();
            },
          );
        }
        return null;
      }
    );
  }
}
