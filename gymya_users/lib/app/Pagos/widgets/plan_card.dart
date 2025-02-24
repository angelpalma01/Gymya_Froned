import 'package:flutter/material.dart';

class PlanDetailsCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final String metodoPago;
  final List<dynamic> gimnasios;

  PlanDetailsCard({required this.plan, required this.metodoPago, required this.gimnasios});

  // Función para obtener la duración del plan
  String obtenerDuracion(Map<String, dynamic> plan) {
    final int? duracionMeses = plan['duracion_meses'];
    final int? duracionSemanas = plan['duracion_semanas'];
    final int? duracionDias = plan['duracion_dias'];

    List<String> partesDuracion = [];

    if (duracionMeses != null && duracionMeses > 0) {
      partesDuracion.add('$duracionMeses meses');
    }
    if (duracionSemanas != null && duracionSemanas > 0) {
      partesDuracion.add('$duracionSemanas semanas');
    }
    if (duracionDias != null && duracionDias > 0) {
      partesDuracion.add('$duracionDias días');
    }

    return partesDuracion.isNotEmpty ? 'Duración de ${partesDuracion.join(', ')}' : 'Duración desconocida';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850], // Color oscuro para la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Detalles del plan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${plan['nombre'] ?? 'Desconocido'}',
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            SizedBox(height: 8),
            Text(
              '\$${plan['costo'] ?? 'Desconocido'}',
              style: TextStyle(fontSize: 16, color: Colors.greenAccent),
            ),
            SizedBox(height: 8),
            Text(
              obtenerDuracion(plan),
              style: TextStyle(fontSize: 16, color: Colors.white60),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Acceso a los gimnasios:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: gimnasios.isNotEmpty
                  ? gimnasios.map<Widget>((gimnasio) => Text(
                        '- $gimnasio',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      )).toList()
                  : [
                      Text(
                        'No se encontraron gimnasios para este plan',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
            ),
            SizedBox(height: 20),
            Text(
              'Método de pago: $metodoPago',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}