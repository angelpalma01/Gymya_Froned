import 'package:flutter/material.dart';
import 'dart:ui'; // Import necesario para usar blur effect

class PlanesModal extends StatelessWidget {
  final List<dynamic> planes;
  final Function(String) onPlanSelected;

  const PlanesModal({
    super.key,
    required this.planes,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Aplicar blur
      child: Align(
        alignment: Alignment.topCenter, // Alinear el contenido en la parte superior
        child: Container(
          margin: EdgeInsets.only(top: 50), // Margen superior para evitar que toque el borde
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.8), // Fondo con opacidad
            borderRadius: BorderRadius.circular(16),
          ),
          width: MediaQuery.of(context).size.width * 0.9, // Anchura del modal
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seleccione un plan de membresía',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16),
                // Listar planes con scroll
                ListView.builder(
                  shrinkWrap: true, // Para que ocupe el espacio justo
                  physics: NeverScrollableScrollPhysics(), // Control del scroll del modal
                  itemCount: planes.length,
                  itemBuilder: (context, index) {
                    final plan = planes[index];
                    return GestureDetector(
                      onTap: () {
                        onPlanSelected(plan['_id']); // Llamar a la función con el _id del plan
                      },
                      child: Card(
                        color: Colors.grey[800],
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan['nombre'],
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(plan['descripcion'], style: TextStyle(color: Colors.white)),
                              Text('Costo: \$${plan['costo']}', style: TextStyle(color: Colors.white)),
                              if (plan['duracion_dias'] != null)
                                Text('Días de duración: ${plan['duracion_dias']}', style: TextStyle(color: Colors.white)),
                              if (plan['duracion_semanas'] != null)
                                Text('Semanas de duración: ${plan['duracion_semanas']}', style: TextStyle(color: Colors.white)),
                              if (plan['duracion_meses'] != null)
                                Text('Meses de duración: ${plan['duracion_meses']}', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}