import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dashboard_screen.dart'; // Importa el archivo del dashboard

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _isLoading = false;

  // URL de la API para el login
  final String apiUrl = 'https://api-gymya-api.onrender.com/api/user/login'; // Cambia esto por la URL de tu API.

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog('Por favor, completa todos los campos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl), // URL de tu API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _emailController.text, // Cambiar a 'username' para tu API
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Obtener token y datos del usuario
        final String token = data['token'];
        final user = data['user'];

        print('Token recibido: $token');
        print('Usuario: $user');

        // Almacenar el token de forma segura
        await _storage.write(key: 'token', value: token);

        // Navegar al dashboard
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => DashboardScreen(token: token, user: user),
  ),
);;
      } else if (response.statusCode == 401) {
        _showErrorDialog('Credenciales inválidas');
      } else {
        final error = jsonDecode(response.body)['message'];
        _showErrorDialog(error ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Iniciar Sesión'),
                  ),
                ],
              ),
            ),
    );
  }
}