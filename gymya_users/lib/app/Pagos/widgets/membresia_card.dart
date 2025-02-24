import 'package:flutter/material.dart';
import 'package:gymya_users/app/funciones/estadoMembresia.dart';

class MembresiaCard extends StatelessWidget {
  final String nombrePlan;
  final DateTime fechaExpiracion;
  final VoidCallback onRenovarPressed;
  final VoidCallback onCancelarPressed;

  const MembresiaCard({
    super.key,
    required this.nombrePlan,
    required this.fechaExpiracion,
    required this.onRenovarPressed,
    required this.onCancelarPressed,
  });

  @override
  Widget build(BuildContext context) {
    final estado = getMembresiaStatus(fechaExpiracion);
    final colorEstado = getColorEstado(estado);
    return Card(
      color: Colors.grey[900], // Color de la tarjeta en gris oscuro
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan de membresía:',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '$nombrePlan',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Estado: $estado',
              style: TextStyle(
                  color: colorEstado,
                  fontWeight: FontWeight.bold,
                ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.list),
                  label: Text('Renovar Membresía', style: TextStyle(color: Colors.white)),
                  onPressed: onRenovarPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel),
                  label: Text('Cancelar', style: TextStyle(color: Colors.white)),
                  onPressed: onCancelarPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}