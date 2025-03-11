import 'dart:convert';
import 'package:http/http.dart' as http;

class UltimaEntrada {
  final String token;
  final String membresiaId;

  UltimaEntrada({required this.token, required this.membresiaId});
  
  // Obtener la última entrada
  Future<Map<String, dynamic>> fetchUltimaEntrada() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId/ultimaAsistencia'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Respuesta exitosa, parseamos el JSON
      return jsonDecode(response.body);
    } else {
      // Para otros errores
      throw Exception('Error al obtener la última entrada: ${response.reasonPhrase}');
    }
  }
}
