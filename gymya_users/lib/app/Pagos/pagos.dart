import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui'; // Import necesario para usar blur effect

class PagosScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId; // Añadimos el _id de la membresía

  const PagosScreen({super.key, required this.token, required this.user, required this.membresiaId});

  @override
  _PagosScreenState createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  bool isLoading = true;
  List<dynamic> planes = [];
  DateTime? _expiryDate; // Fecha de expiración de la membresía

  @override
  void initState() {
    super.initState();
    _fetchPlanData();
    _fetchMembresiaData();
  }

  // Función para obtener la membresía
  Future<void> _fetchMembresiaData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-gymya-api.onrender.com/api/${widget.membresiaId}'),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Pasa el token en la cabecera
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _expiryDate = DateTime.parse(data['fecha_fin']); // Fecha de fin de la membresía
          isLoading = false;
        });
      } else {
        throw Exception('Error al obtener la membresía');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función para obtener los planes
  Future<void> _fetchPlanData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-gymya-api.onrender.com/api/${widget.membresiaId}/planesUser'),
        headers: {
          'Authorization': 'Bearer ${widget.token}'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          planes = data;
          isLoading = false;
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

  // Función para formatear la fecha
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Función para determinar el estado de la membresía
  String _getMembresiaStatus(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;

    if (difference > 5) {
      return 'Activa';
    } else if (difference >= 0 && difference <= 5) {
      return 'Próxima a expirar';
    } else {
      return 'Expirada';
    }
  }

  // Función (aún no definida) que manejará el ID del plan seleccionado
  void _seleccionarPlan(String planId) {
    print('Plan seleccionado: $planId');
    // Lógica adicional para manejar el plan seleccionado
  }

  // Mostrar modal de membresías con tarjetas centradas y scroll
  void _showMembresiasModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Fondo transparente para aplicar blur
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Aplicar blur
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900]!.withOpacity(0.8), // Fondo con opacidad
                borderRadius: BorderRadius.circular(16),
              ),
              width: MediaQuery.of(context).size.width * 0.9, // Anchura del modal
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Renovar Membresía',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    // Listar planes con scroll
                    ListView.builder(
                      shrinkWrap: true, // Para que ocupe el espacio justo
                      physics: NeverScrollableScrollPhysics(), // Control del scroll del modal
                      itemCount: planes.length,
                      itemBuilder: (context, index) {
                        final plan = planes[index];
                        return GestureDetector(
                          onTap: () {
                            _seleccionarPlan(plan['_id']); // Llamar a la función con el _id del plan
                          },
                          child: Card(
                            color: Colors.grey[800],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    plan['nombre'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  Text(plan['descripcion'], style: TextStyle(color: Colors.white)),
                                  Text('Costo: \$${plan['costo']}', style: TextStyle(color: Colors.white)),
                                  if (plan['duracion_dias'] != null)
                                    Text('Duración (días): ${plan['duracion_dias']}', style: TextStyle(color: Colors.white)),
                                  if (plan['duracion_semanas'] != null)
                                    Text('Duración (semanas): ${plan['duracion_semanas']}', style: TextStyle(color: Colors.white)),
                                  if (plan['duracion_meses'] != null)
                                    Text('Duración (meses): ${plan['duracion_meses']}', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo de la pantalla en negro
      appBar: AppBar(
        title: Text('Pagos y Membresías', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black, // Fondo del AppBar en negro
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Encabezado con nombre de sección y descripción
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.purple, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Mi Billetera',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Consulta tus pagos pendientes y renueva tu membresía fácilmente.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              SizedBox(height: 16),

              // Card de Membresía
              Card(
                color: Colors.grey[900], // Color de la tarjeta en gris oscuro
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Membresía', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      // Mostrar estado y fecha de expiración
                      if (_expiryDate != null)
                        Text('Estado: ${_getMembresiaStatus(_expiryDate!)}', style: TextStyle(color: _getMembresiaStatus(_expiryDate!) == 'Activa' ? Colors.green : _getMembresiaStatus(_expiryDate!) == 'Próxima a expirar' ? Colors.orange : Colors.red)),
                      if (_expiryDate != null)
                        Text('Válida hasta: ${_formatDate(_expiryDate!)}', style: TextStyle(color: Colors.white)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.list),
                            label: Text('Renovar Membresía', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              _showMembresiasModal(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.cancel),
                            label: Text('Cancelar', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Lógica para cancelar membresía
                            },
                            style: ElevatedButton.styleFrom(
                               backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}