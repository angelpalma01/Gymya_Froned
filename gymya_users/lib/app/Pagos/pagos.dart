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
  List<dynamic> planes = [];
  bool membresiaActiva = true; // Cambia según el estado de la membresía

  final String planesURL = 'https://api-gymya-api.onrender.com/api/admin/planes';

  @override
  void initState() {
    super.initState();
    _fetchPlanData();
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showMembresiasModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900], // Fondo del modal en gris oscuro
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tipos de Membresías',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: planes.length,
                  itemBuilder: (context, index) {
                    final plan = planes[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color: Colors.grey[800], // Color de las tarjetas dentro del modal
                      child: ListTile(
                        title: Text(
                          plan['nombre'],
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan['descripcion'], style: TextStyle(color: Colors.white)),
                            Text('Costo: \$${plan['costo']}', style: TextStyle(color: Colors.white)),
                            if (plan['duracion_dias'] != null) Text('Duración (días): ${plan['duracion_dias']}', style: TextStyle(color: Colors.white)),
                            if (plan['duracion_semanas'] != null) Text('Duración (semanas): ${plan['duracion_semanas']}', style: TextStyle(color: Colors.white)),
                            if (plan['duracion_meses'] != null) Text('Duración (meses): ${plan['duracion_meses']}', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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

              // Card de Próximos Pagos
              Card(
                color: Colors.grey[900], // Color de la tarjeta en gris oscuro
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Próximos Pagos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Text('Subtotal: \$100.00', style: TextStyle(color: Colors.white)), // Cambia este valor dinámicamente
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.credit_card),
                            label: Text('Pagar con Tarjeta', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Lógica para pagar con tarjeta
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 123, 11, 131), // Color del botón en rojo
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(Icons.history),
                            label: Text('Historial', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Lógica para ver el historial
                            },
                            style: ElevatedButton.styleFrom(
                               backgroundColor: const Color.fromARGB(255, 113, 19, 12),// Color del botón en rojo
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      Text('Estado: ${membresiaActiva ? 'Activa' : 'Inactiva'}', style: TextStyle(color: membresiaActiva ? Colors.green : Colors.red)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                          ElevatedButton.icon(
                            icon: Icon(Icons.history),
                            label: Text('Historial de Entradas', style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              // Lógica para ver historial de entradas
                            },
                            style: ElevatedButton.styleFrom(
                               backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.list),
                          label: Text('Ver Tipos de Membresías', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _showMembresiasModal(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 113, 19, 12), // Color del botón en rojo
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(), // Menú inferior igual al Dashboard
    );
  }

  // Menú inferior igual al Dashboard
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Couch'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horarios'),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
      ],
    );
  }
}