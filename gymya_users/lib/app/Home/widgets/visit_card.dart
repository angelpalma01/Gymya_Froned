import 'package:flutter/material.dart';
import 'package:gymya_users/app/Funciones/formatearFecha.dart';

class VisitCard extends StatelessWidget {
  final String ultimaVisita;
  final String nombreGym;
  final VoidCallback onEnterPressed;
  final VoidCallback onHistoryPressed;

  const VisitCard({
    required this.ultimaVisita,
    required this.nombreGym,
    required this.onEnterPressed,
    required this.onHistoryPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 325, // Limitar el ancho máximo a 365px
      ),
      padding: const EdgeInsets.all(16), // Centramos el contenido si la pantalla es grande
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Última visita:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            ultimaVisita != 'Aún no hay visitas'
                ? '${formatDateTime(ultimaVisita)} en $nombreGym.'
                : 'Aún no hay visitas en $nombreGym.',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          // Cambiar a Column si el ancho es pequeño, de lo contrario usar Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 250) {
                // Mostrar los botones en fila si el ancho es mayor a 280px
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onEnterPressed,
                      child: const Text(
                        'Código QR',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 30), // Espacio fijo de 20 píxeles
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onHistoryPressed,
                      child: const Text(
                        'Historial',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
                } else {
                  // Mostrar los botones uno debajo del otro si el ancho es menor a 280px
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onEnterPressed,
                        child: const Text(
                          'Entrada',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 14), // Espacio entre los botones
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: onHistoryPressed,
                        child: const Text(
                          'Historial',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
    );
  }
}