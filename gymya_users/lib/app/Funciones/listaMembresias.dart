import 'dart:convert';
import 'package:http/http.dart' as http;

class listaMembresias {
  final String token;

  listaMembresias({required this.token});

  // Obtener la lista de membresías
  Future<List<dynamic>> fetchMembresias() async {
    final response = await http.get(
      Uri.parse('https://api-gymya-api.onrender.com/api/membresias'),
      headers: {
        'Authorization': 'Bearer $token',
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