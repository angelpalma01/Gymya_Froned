import 'dart:convert';
import 'package:http/http.dart' as http;

class Planindividual {
  final String token;
  final String planId;

  Planindividual({required this.token, required this.planId});

  Future<Map<String, dynamic>> fetchPlanData() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$planId/planIndividual'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar las membresías');
    }
  }
}