import 'package:flutter/material.dart';
import 'package:gymya_users/app/funciones/formatearFecha.dart';

class MembershipCard extends StatelessWidget {
  final String nombrePlan;
  final DateTime expiryDate;
  final VoidCallback onConfirmacionPressed;

  const MembershipCard({
    required this.nombrePlan,
    required this.expiryDate,
    required this.onConfirmacionPressed,
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
          Text(
            '$nombrePlan',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fecha de vencimiento: ${formatFecha(expiryDate)}',
            style: TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onConfirmacionPressed,
            child: const Text(
              'Pagar ahora', 
              style: TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}