import 'package:flutter/material.dart';
import 'package:gymya_users/app/Funciones/formatearFecha.dart';

class AsistenciaCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String fechaHoraEntrada;
  final String? fechaHoraSalida; // Permitir null
  final String nombreGym;

  const AsistenciaCard({
    super.key,
    required this.icon,
    required this.color,
    required this.fechaHoraEntrada,
    this.fechaHoraSalida, // Permitir null
    required this.nombreGym,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
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
          'Asistencia en $nombreGym',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entrada: ${formatDateTime(fechaHoraEntrada)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
            if (fechaHoraSalida != null)
              Text(
                'Salida: ${formatDateTime(fechaHoraSalida!)}', // Mostrar si existe
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
          ],
        ),
      ),
    );
  }
}