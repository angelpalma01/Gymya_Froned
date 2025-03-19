import 'dart:convert';
import 'package:http/http.dart' as http;

class ContarAsistencias {
  final String token;
  final String gymId;

  ContarAsistencias({required this.token, required this.gymId});

  Future <Map<String, dynamic>> Contar() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$gymId/contarAsistencias'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Respuesta exitosa, parseamos el JSON
      return jsonDecode(response.body);
    } else {
      // Para otros errores
      throw Exception('Error al obtener el número de asistencias: ${response.reasonPhrase}');
    }
  }
}