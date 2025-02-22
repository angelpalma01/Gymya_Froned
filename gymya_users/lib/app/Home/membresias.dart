import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Para formatear fechas
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
        final responseBody = json.decode(response.body);
        if (responseBody is List) {
          setState(() {
            membresias = responseBody; // Parsear la respuesta JSON
            isLoading = false;
          });
        } else {
          throw Exception('Formato de respuesta inválido');
        }
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

  // Función para formatear los gimnasios
  String formatGimnasios(List<dynamic> gimnasios) {
    if (gimnasios.isEmpty) {
      return 'No hay gimnasios disponibles';
    }
    return gimnasios.join(', '); // Unir los gimnasios con comas
  }

  // Función para formatear la fecha
  String formatFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      final parsedDate = DateFormat('dd MMM yyy').format(dateTime);
      return '$parsedDate'; // Formato en español
    } catch (e) {
      return 'Fecha no disponible';
    }
  }

  // Función para determinar el estado de la membresía
  String getEstadoMembresia(String fechaFin) {
    try {
      final fechaFinDate = DateTime.parse(fechaFin);
      final ahora = DateTime.now();
      final diferenciaDias = fechaFinDate.difference(ahora).inDays;

      if (diferenciaDias > 5) {
        return 'Activa';
      } else if (diferenciaDias >= 0 && diferenciaDias <= 5) {
        return 'Casi a expirar';
      } else {
        return 'Expirada';
      }
    } catch (e) {
      return 'Estado no disponible';
    }
  }

  // Función para obtener el color del estado
  Color getColorEstado(String estado) {
    switch (estado) {
      case 'Activa':
        return Colors.green;
      case 'Casi a expirar':
        return Colors.orange;
      case 'Expirada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Selecciona una Membresía',
          style: TextStyle(color: Colors.white), // Texto blanco en el AppBar
        ),
        backgroundColor: Colors.black, // Fondo negro en el AppBar
        iconTheme: IconThemeData(color: Colors.white), // Ícono blanco
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.purple)) // Loader morado
          : ListView.builder(
              itemCount: membresias.length,
              itemBuilder: (context, index) {
                final membresia = membresias[index];
                final fechaFin = membresia['fecha_fin'] ?? '';
                final estado = getEstadoMembresia(fechaFin);
                final colorEstado = getColorEstado(estado);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () {
                      goToNextScreen(membresia['membresia_id']); // Pasar el _id a la siguiente pantalla
                    },
                    borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[900], // Fondo gris oscuro
                        borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            membresia['nombre_plan'] ?? 'Nombre no disponible',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Disponible hasta: ${formatFecha(fechaFin)}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Acceso a los gimnasios: ${formatGimnasios(membresia['gimnasios'])}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estado: $estado',
                            style: TextStyle(
                              color: colorEstado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}