import 'dart:convert';
import 'package:http/http.dart' as http;

class datosMembresia {
  final String token;
  final String membresiaId;

  datosMembresia({required this.token, required this.membresiaId});

  // Obtener datos de la membresía
  Future<Map<String, dynamic>> fetchMembresiaData() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener la membresía');
    }
  }
}