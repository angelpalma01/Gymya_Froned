import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  DashboardScreen({required this.token, required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storage = FlutterSecureStorage();
  List<dynamic> _asistencias = [];
  bool _isLoading = true;
  final TextEditingController _tipoAccesoController = TextEditingController();
  final TextEditingController _gymIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAsistencias();
  }

  Future<void> _fetchAsistencias() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/user/asistencias'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data); // Imprime la respuesta para verificar su estructura

      if (data is Map<String, dynamic> && data['data'] is List) {
        setState(() {
          _asistencias = data['data'];
          _isLoading = false;
        });
      } else {
        _showErrorDialog('La respuesta de la API no contiene una lista de asistencias');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al obtener las asistencias');
    }
  }

  Future<void> _createAsistencia() async {
    final response = await http.post(
      Uri.parse('https://api-gymya-api.onrender.com/api/user/asistencias'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
      body: jsonEncode({
        'usuario_id': widget.user['id'],
        'tipo_acceso': _tipoAccesoController.text,
        'gym_id': int.parse(_gymIdController.text),
      }),
    );

    if (response.statusCode == 201) {
      final newAsistencia = jsonDecode(response.body);
      setState(() {
        _asistencias.add(newAsistencia);
      });
      _tipoAccesoController.clear();
      _gymIdController.clear();
    } else {
      _showErrorDialog('Error al crear la asistencia');
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
      appBar: AppBar(
        title: Text('Bienvenido, ${widget.user['nombre_completo']}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _storage.delete(key: 'token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _asistencias.length,
                    itemBuilder: (context, index) {
                      final asistencia = _asistencias[index];
                      return ListTile(
                        title: Text('Fecha: ${asistencia['fecha_hora']}'),
                        subtitle: Text('Tipo de acceso: ${asistencia['tipo_acceso']}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _tipoAccesoController,
                        decoration: InputDecoration(labelText: 'Tipo de Acceso'),
                      ),
                      TextField(
                        controller: _gymIdController,
                        decoration: InputDecoration(labelText: 'Gym ID'),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _createAsistencia,
                        child: Text('Crear Asistencia'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}