import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Para formatear la fecha y hora
import 'package:gymya_users/app/Pagos/pagos.dart'; // Importa PagosScreen
import 'package:gymya_users/app/Home/home.dart'; // Importa HomeScreen
import 'package:gymya_users/app/Entrenadores/entrenadores.dart'; // Importa EntrenadoresScreen
import 'package:gymya_users/app/horarios_gym/horariosgym.dart'; // Importa HorariosScreen

class HistorialEntradasScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const HistorialEntradasScreen({super.key, required this.token, required this.user});

  @override
  _HistorialEntradasScreenState createState() => _HistorialEntradasScreenState();
}

class _HistorialEntradasScreenState extends State<HistorialEntradasScreen> {
  final _storage = FlutterSecureStorage();
  List<dynamic> _asistencias = [];
  bool _isLoading = true;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              token: widget.token,
              user: widget.user,
            ),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EntrenadoresScreen(
              token: widget.token,
              user: widget.user,
            ),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HorariosScreen(
              token: widget.token,
              user: widget.user,
            ),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PagosScreen(
              token: widget.token,
              user: widget.user,
            ),
          ),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAsistencias();
  }

  Future<void> _fetchAsistencias() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/asistenciasUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic> && data['asistencias'] is List) {
        setState(() {
          _asistencias = data['asistencias'];
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
        title: Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  // Función para formatear la fecha y hora
  String _formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime); // Formato de fecha: 13 Feb 2025
    final formattedTime = DateFormat('hh:mm a').format(dateTime); // Formato de hora: 02:21 AM
    return '$formattedDate\n$formattedTime'; // Fecha y hora en líneas separadas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Historial de Asistencias',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await _storage.delete(key: 'token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            )
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

                    // Ícono y color según el tipo de acceso
                    final icon = tipoAcceso == 'Entrada' ? Icons.login : Icons.logout;
                    final color = tipoAcceso == 'Entrada' ? Colors.green : Colors.red;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          icon,
                          color: color,
                          size: 32,
                        ),
                        title: Text(
                          _formatDateTime(fechaHora), // Fecha y hora formateadas
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          tipoAcceso, // Muestra si es "Entrada" o "Salida"
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Couch'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horarios'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
        ],
      ),
    );
  }
}