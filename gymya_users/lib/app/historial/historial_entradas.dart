import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistorialEntradasScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  HistorialEntradasScreen({required this.token, required this.user});

  @override
  _HistorialEntradasScreenState createState() =>
      _HistorialEntradasScreenState();
}

class _HistorialEntradasScreenState extends State<HistorialEntradasScreen> {
  final _storage = FlutterSecureStorage();
  List<dynamic> _asistencias = [];
  bool _isLoading = true;

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

      if (data is Map<String, dynamic> && data['data'] is List) {
        setState(() {
          _asistencias = data['data'];
          _isLoading = false;
        });
      } else {
        _showErrorDialog('La respuesta de la API no contiene una lista válida');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al obtener las asistencias');
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
        title: Text('Historial de Asistencias'),
        backgroundColor: Colors.black,
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
          : _asistencias.isEmpty
              ? Center(
                  child: Text(
                    'No hay asistencias registradas.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _asistencias.length,
                  itemBuilder: (context, index) {
                    final asistencia = _asistencias[index];
                    final tipoAcceso = asistencia['tipo_acceso'] ?? "No especificado";
                    final fechaHora = asistencia['fecha_hora'] ?? "Sin fecha";

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          tipoAcceso.toLowerCase() == 'entrada'
                              ? Icons.login
                              : Icons.logout,
                          color: tipoAcceso.toLowerCase() == 'entrada'
                              ? Colors.green
                              : Colors.red,
                          size: 32,
                        ),
                        title: Text(
                          'Fecha y hora: $fechaHora',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Tipo de acceso: $tipoAcceso',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
