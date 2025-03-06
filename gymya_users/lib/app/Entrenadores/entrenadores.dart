import 'package:flutter/material.dart';
import 'package:gymya_users/app/Entrenadores/widgets/entrenadores_card.dart';
import 'package:gymya_users/app/funciones/datosMembresia.dart';
import 'package:gymya_users/app/funciones/listaEntrenadores.dart';
import 'package:gymya_users/app/Entrenadores/widgets/header.dart';

class EntrenadoresScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId;

  const EntrenadoresScreen({super.key, required this.token, required this.user, required this.membresiaId});

  @override
  _EntrenadoresScreenState createState() => _EntrenadoresScreenState();
}

class _EntrenadoresScreenState extends State<EntrenadoresScreen> {
  bool isLoading = true;
  late datosMembresia _datosMembresia;
  List<dynamic> entrenadoresList = [];

  @override
  void initState() {
    super.initState();
    _datosMembresia = datosMembresia(token: widget.token, membresiaId: widget.membresiaId);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final membresiaData = await _datosMembresia.fetchMembresiaData();
      final List<dynamic> gymIds = membresiaData['gym_id'];

      // Iterar sobre cada gymId y obtener entrenadores
      for(String gymId in gymIds) {
        final EntrenadoresService service = 
          EntrenadoresService(token: widget.token, gymId: gymId);
        final List<dynamic> entrenadores = await service.fetchEntrenadores();

        setState(() {
          entrenadoresList.addAll(entrenadores);
        });
      }

      setState(() {
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding a los lados
                child: Column(
                  children: [
                      Text(
                        'Consulta la información de los entrenadores disponibles.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        textAlign: TextAlign.center, // Centrar el texto
                      ),
                    SizedBox(height: 24),
                    if (isLoading)
                      const CircularProgressIndicator(), // Indicador de carga
                    if(!isLoading && entrenadoresList.isNotEmpty)
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: entrenadoresList.length,
                        itemBuilder:(context, index) {
                          final entrenador = entrenadoresList[index];
                          return EntrenadoresCard(
                            entrenador: {
                              'nombre': entrenador['nombre_completo'] ?? 'Nombre no disponible',
                              'imagenUrl': entrenador['imagen'] ?? 'https://via.placeholder.com/150', // Imagen por defecto
                              'especialidad': entrenador['especialidad'] ?? 'Especialidad no disponible',
                            },
                          );
                        },
                      )
                  ],
                ),
              ),
            ) 
          )
        ],
      )
    );
  }
}