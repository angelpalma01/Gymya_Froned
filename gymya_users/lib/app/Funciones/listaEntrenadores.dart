import 'dart:convert';
import 'package:http/http.dart' as http;

class EntrenadoresService {
  final String token;
  final String gymId;

  EntrenadoresService({required this.token, required this.gymId});

  Future<List<dynamic>> fetchEntrenadores() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$gymId/entrenadores'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Verifica si la respuesta es una lista directamente
      if (data is List) {
        return data;
      } else {
        throw Exception('La respuesta de la API no contiene una lista válida');
      }
    } else {
      throw Exception('Error al obtener los entrenadores');
    }
  }
}