import 'package:flutter/material.dart';
import 'package:gymya_users/app/horarios_gym/widgets/header.dart';
import 'package:gymya_users/app/horarios_gym/widgets/gimnasiosCard.dart';
import 'package:gymya_users/app/Funciones/listaGimnasios.dart'; // Importa la lista de gimnasios

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
  List<dynamic> gimnasios = [];
  late GimnasiosService _listaGimnasios;

  @override
  void initState() {
    super.initState();
    _listaGimnasios = GimnasiosService(token: widget.token, membresiaId: widget.membresiaId);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final listaGimnasios = await _listaGimnasios.fetchGimnasios(); // Cambia a fetchAsistencias
      setState(() {
        gimnasios = listaGimnasios;
        isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
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
                          return Gimnasioscard(
                            gimnasio: {
                              'imagen': gimnasio['imagen'] ?? 'https://via.placeholder.com/150',
                              'nombre': gimnasio['nombre'] ?? 'Nombre no disponible',
                              'direccion': gimnasio['direccion'] ?? 'Dirección no disponible',
                              'usuariosDentro': gimnasio['usuariosDentro'] ?? 0,
                              'horario': gimnasio['horario'] ?? 'Horario no disponible',
                            },
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
