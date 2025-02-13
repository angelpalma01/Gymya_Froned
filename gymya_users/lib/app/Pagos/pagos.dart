import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PagosScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const PagosScreen({super.key, required this.token, required this.user});

  @override
  _PagosScreenState createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<dynamic> planes = []; // Almacena los datos de los planes

  final String planesURL = 'https://api-gymya-api.onrender.com/api/admin/planes';

  @override
  void initState() {
    super.initState();
    _fetchPlanData(); // Llamada para obtener los datos al iniciar la pantalla
  }

  Future<void> _fetchPlanData() async {
    try {
      final response = await http.get(
        Uri.parse(planesURL),
        headers: {
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Decodificar la respuesta JSON

        // Actualizamos el estado con los datos recibidos
        setState(() {
          planes = data; // Guardar los datos de planes
          isLoading = false; // Desactivar el estado de carga
        });
      } else {
        throw Exception('Error al obtener los planes de membresía');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para manejar la selección del BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Planes de Membresía'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Mostrar un indicador de carga mientras se obtienen los datos
          : ListView.builder(
              itemCount: planes.length,
              itemBuilder: (context, index) {
                final plan = planes[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(plan['nombre'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plan['descripcion']),
                        Text('Costo: \$${plan['costo']}'),
                        if (plan['duracion_dias'] != null) Text('Duración (días): ${plan['duracion_dias']}'),
                        if (plan['duracion_semanas'] != null) Text('Duración (semanas): ${plan['duracion_semanas']}'),
                        if (plan['duracion_meses'] != null) Text('Duración (meses): ${plan['duracion_meses']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Couch'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horarios'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}