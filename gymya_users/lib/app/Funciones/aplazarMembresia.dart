import 'dart:convert';
import 'package:http/http.dart' as http;

class Aplazarmembresia {
  final String token;
  final String membresiaId;
  final String planId;

  Aplazarmembresia({required this.token, required this.membresiaId, required this.planId});

  // Aplazar la membresía
  Future<Map<String, dynamic>> aplazar() async {
    final response = await http.put(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId/aplazar'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Indicar que el cuerpo es JSON
      },
      body: jsonEncode({
        'plan_id': planId, // Incluir el planId en el cuerpo de la solicitud
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al aplazar su membresía');
    }
  }
}