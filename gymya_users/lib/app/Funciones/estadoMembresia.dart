import 'package:flutter/material.dart';

// Función para determinar el estado de la membresía
String getMembresiaStatus(DateTime expiryDate) {
  final now = DateTime.now();
  final difference = expiryDate.difference(now).inDays;

  if (difference > 5) {
    return 'Activa';
  } else if (difference >= 0 && difference <= 5) {
    return 'Próxima a expirar';
  } else {
    return 'Expirada';
  }
}

// Función para obtener el color del estado
Color getColorEstado(String estado) {
  switch (estado) {
    case 'Activa':
      return Colors.green;
    case 'Próxima a expirar':
      return Colors.orange;
    case 'Expirada':
      return Colors.red;
    default:
      return Colors.grey;
  }
}