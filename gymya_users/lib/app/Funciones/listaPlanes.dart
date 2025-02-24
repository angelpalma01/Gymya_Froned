import 'dart:convert';
import 'package:http/http.dart' as http;

class listaPlanes {
  final String token;
  final String membresiaId;

  listaPlanes({required this.token, required this.membresiaId});

  Future<List<dynamic>> fetchPlanData() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/$membresiaId/planesUser'),
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (responseBody is List) {
        return responseBody;
      } else {
        throw Exception('Formato de respuesta inválido');
      }
    } else {
      throw Exception('Error al cargar las membresías');
    }
  }
}