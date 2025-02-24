import 'package:flutter/material.dart';
import 'package:gymya_users/app/Funciones/formatearFecha.dart';

class AsistenciaCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String fechaHora;
  final String nombreGym;
  final String tipoAcceso;

  const AsistenciaCard({
    super.key,
    required this.icon,
    required this.color,
    required this.fechaHora,
    required this.nombreGym,
    required this.tipoAcceso,
  });

  @override
  Widget build(BuildContext context) {
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
          formatDateTime(fechaHora),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '$tipoAcceso de $nombreGym', // Muestra "Entrada de (nombreGym)" o "Salida de (nombreGym)"
          style: TextStyle(
            fontSize: 14,
            color: Colors.white60,
          ),
        ),
      ),
    );
  }
}