import 'package:flutter/material.dart';
import '/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (ctx) => LoginScreen(),
        '/dashboard': (ctx) => Scaffold(
              appBar: AppBar(title: Text('Dashboard')),
              body: Center(child: Text('Bienvenido al Dashboard')),
            ),
      },
    );
  }
}
