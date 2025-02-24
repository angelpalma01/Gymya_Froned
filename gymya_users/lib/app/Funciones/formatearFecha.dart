import 'package:intl/intl.dart';

//Función para formatear la fecha en dd/MM/yy
String formatFecha(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

// Formatear fecha y hora en formato dd MMMM yyyy, hh:mm a
String formatDateTime(String dateTimeString) {
  try {
    final dateTime = DateTime.parse(dateTimeString);
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('hh:mm a');
    return '${dateFormat.format(dateTime)}, ${timeFormat.format(dateTime)}';
  } catch (e) {
    return 'Fecha no válida'; // Manejo de errores
  }
}