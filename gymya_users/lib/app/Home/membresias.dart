import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Home/home.dart'; // Importa el archivo del dashboard

// Pantalla para listar las membresías
class MembresiasList extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const MembresiasList({super.key, required this.token, required this.user});

  @override
  _MembresiasListState createState() => _MembresiasListState();
}

class _MembresiasListState extends State<MembresiasList> {
  // Endpoint para ver la lista de membresías
  final String membresiasURL = 'https://api-gymya-api.onrender.com/api/membresias';
  List<dynamic> membresias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMembresias();
  }

  // Función para obtener la lista de membresías
  Future<void> fetchMembresias() async {
    try {
      final response = await http.get(Uri.parse(membresiasURL), headers: {
        'Authorization': 'Bearer ${widget.token}', // Añadir token en los headers
      });

      if (response.statusCode == 200) {
        setState(() {
          membresias = json.decode(response.body); // Parsear la respuesta JSON
          isLoading = false;
        });
      } else {
        throw Exception('Error al cargar las membresías');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para ir a la siguiente pantalla con el ID de la membresía seleccionada
  void goToNextScreen(String membresiaId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          token: widget.token, // Usar widget.token
          user: widget.user, // Usar widget.user
          membresiaId: membresiaId, // Pasar el _id de la membresía
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecciona una Membresía'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar un loader mientras se cargan los datos
          : ListView.builder(
              itemCount: membresias.length,
              itemBuilder: (context, index) {
                final membresia = membresias[index];
                return ListTile(
                  title: Text(membresia['nombre_plan']), // Mostrar el nombre del plan
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fecha fin: ${membresia['fecha_fin']}'), // Mostrar la fecha de fin
                      Text('Acceso a los gimnasios: ${membresia['gimnasios']}'), // Mostrar los gimnasios formateados
                    ],
                  ),
                  onTap: () {
                    goToNextScreen(membresia['membresia_id']); // Pasar el _id a la siguiente pantalla
                  },
                );
              },
            ),
    );
  }
}