import 'package:flutter/material.dart';
import 'package:gymya_users/app/Funciones/listaAsistencias.dart';
import 'package:gymya_users/app/Asistencias/widgets/header.dart'; // Importa el nuevo header
import 'package:gymya_users/app/Asistencias/widgets/asistencias_card.dart'; // Card de asistencias

class HistorialEntradasScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId;

  const HistorialEntradasScreen({
    super.key,
    required this.token,
    required this.user,
    required this.membresiaId,
  });

  @override
  _HistorialEntradasScreenState createState() => _HistorialEntradasScreenState();
}

class _HistorialEntradasScreenState extends State<HistorialEntradasScreen> {
  List<dynamic> _asistencias = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAsistencias();
  }

  Future<void> _fetchAsistencias() async {
    try {
      final asistenciasService = AsistenciasService(
        token: widget.token,
        membresiaId: widget.membresiaId,
      );
      final asistencias = await asistenciasService.fetchAsistencias();
      setState(() {
        _asistencias = asistencias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Error al obtener las asistencias: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Header(),
          Expanded(
            child: _isLoading
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
                        padding: EdgeInsets.all(14),
                        itemCount: _asistencias.length,
                        itemBuilder: (context, index) {
                          final asistencia = _asistencias[index];
                          final fechaEntrada = asistencia['fecha_hora_entrada'] ?? "Sin entrada";
                          final fechaSalida = asistencia['fecha_hora_salida'];
                          final nombreGym = asistencia['gimnasioNombre'] ?? "No especificado";

                          final icon = fechaSalida == null ? Icons.login : Icons.logout;
                          final color = fechaSalida == null ? Colors.green : Colors.red;

                          return AsistenciaCard(
                            icon: icon,
                            color: color,
                            fechaHoraEntrada: fechaEntrada,
                            fechaHoraSalida: fechaSalida,
                            nombreGym: nombreGym,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}