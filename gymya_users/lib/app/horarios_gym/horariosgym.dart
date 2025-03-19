import 'package:flutter/material.dart';
import 'package:gymya_users/app/horarios_gym/widgets/header.dart';
import 'package:gymya_users/app/horarios_gym/widgets/gimnasiosCard.dart';
import 'package:gymya_users/app/Funciones/listaGimnasios.dart'; // Importa la lista de gimnasios
import 'package:gymya_users/app/Funciones/contarAsistencias.dart'; // Función para contar las asistencias

class HorariosScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId; // Añadimos el _id de la membresía

  const HorariosScreen({super.key, required this.token, required this.user, required this.membresiaId});

  @override
  _HorariosScreenState createState() => _HorariosScreenState();
}

class _HorariosScreenState extends State<HorariosScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> gimnasios = []; // Modificamos el tipo a Map para agregar datos adicionales
  late GimnasiosService _listaGimnasios;

  @override
  void initState() {
    super.initState();
    _listaGimnasios = GimnasiosService(token: widget.token, membresiaId: widget.membresiaId);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final listaGimnasios = await _listaGimnasios.fetchGimnasios();
      // Por cada gimnasio, obtenemos las asistencias
      for (var gimnasio in listaGimnasios) {
        try {
          final contarService = ContarAsistencias(token: widget.token, gymId: gimnasio['_id']);
          final response = await contarService.Contar();
          final usuariosDentro = response['asistencias'] ?? 0; // Asistencias, si no existe, 0
          
          // Agregamos el número de usuarios dentro a los datos del gimnasio
          gimnasio['usuariosDentro'] = usuariosDentro;
        } catch (e) {
          print('Error al contar asistencias para gimnasio ${gimnasio['_id']}: $e');
          gimnasio['usuariosDentro'] = 0; // Si hay error, asignamos 0
        }
      }
      setState(() {
        gimnasios = List<Map<String, dynamic>>.from(listaGimnasios); // Convertimos a lista de Map
        isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      // Mostrar un mensaje de error en la interfaz de usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los gimnasios: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo de la pantalla en negro
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Text(
                      'Revisa el horario de los gimnasios y el número de usuarios dentro del gimnasio',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (isLoading)
                      const CircularProgressIndicator(), // Indicador de carga
                    if (!isLoading && gimnasios.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: gimnasios.length,
                        itemBuilder: (context, index) {
                          final gimnasio = gimnasios[index];

                          return Column(
                            children: [
                              Gimnasioscard(
                                gimnasio: {
                                  'imagen': gimnasio['imagen'] ?? 'https://via.placeholder.com/150',
                                  'nombre': gimnasio['nombre'] ?? 'Nombre no disponible',
                                  'direccion': gimnasio['direccion'] ?? 'Dirección no disponible',
                                  'horario': gimnasio['horario'] ?? 'Horario no disponible',
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Usuarios dentro: ${gimnasio['usuariosDentro']}',
                                  style: const TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    if (!isLoading && gimnasios.isEmpty)
                      const Text(
                        'No hay gimnasios disponibles',
                        style: TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}