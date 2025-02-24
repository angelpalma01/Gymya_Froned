import 'package:flutter/material.dart';
import 'package:gymya_users/app/funciones/formatearFecha.dart';
import 'package:gymya_users/app/funciones/estadoMembresia.dart';

class MembresiaCard extends StatelessWidget {
  final Map<String, dynamic> membresia;
  final VoidCallback onTap;

  const MembresiaCard({required this.membresia, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final fechaFin = DateTime.parse(membresia['fecha_fin']);
    final estado = getMembresiaStatus(fechaFin);
    final colorEstado = getColorEstado(estado);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                membresia['nombre_plan'] ?? 'Nombre no disponible',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Acceso a: ${membresia['gimnasios'].join(', ')}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'Disponible hasta: ${formatFecha(fechaFin)}',
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(height: 4),
              Text(
                'Estado: $estado',
                style: TextStyle(
                  color: colorEstado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}