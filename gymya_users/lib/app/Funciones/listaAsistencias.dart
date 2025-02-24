// Funciones/asistencias_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AsistenciasService {
  final String token;
  final String membresiaId;

  AsistenciasService({required this.token, required this.membresiaId});

  Future<List<dynamic>> fetchAsistencias() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId/asistenciasUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data['asistencias'] is List) {
        return data['asistencias'];
      } else {
        throw Exception('La respuesta de la API no contiene una lista válida');
      }
    } else {
      throw Exception('Error al obtener las asistencias');
    }
  }
}