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
      padding: const EdgeInsets.all(16),
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
              color: Colors.white, fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
          ),
          const SizedBox(height: 4),
          Text(
            '${formatDateTime(ultimaVisita)} en ${nombreGym}.',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onEnterPressed,
                child: Text(
                  'Entrada al gym',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onHistoryPressed,
                child: const Text('Ver Historial', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}