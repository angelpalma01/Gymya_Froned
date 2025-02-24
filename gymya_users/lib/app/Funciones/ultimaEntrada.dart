import 'dart:convert';
import 'package:http/http.dart' as http;

class ultimaEntrada {
  final String token;
  final String membresiaId;

  ultimaEntrada({required this.token, required this.membresiaId});
  
  // Obtener la última entrada
  Future<Map<String, dynamic>> fetchUltimaEntrada() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId/ultimaAsistencia'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener la última entrada');
    }
  }
}