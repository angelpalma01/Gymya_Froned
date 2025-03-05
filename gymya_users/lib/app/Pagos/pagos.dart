import 'package:flutter/material.dart';
import 'package:gymya_users/app/Pagos/widgets/header.dart'; // Header
import 'package:gymya_users/app/Pagos/widgets/membresia_card.dart'; // carta de membresía
import 'package:gymya_users/app/Pagos/confirmacion.dart'; // pantalla de confirmación
import 'package:gymya_users/app/Pagos/widgets/planes_modal.dart'; // modal de planes
import 'package:gymya_users/app/Funciones/datosMembresia.dart'; // Importa el servicio de planes
import 'package:gymya_users/app/Funciones/listaPlanes.dart'; // Importa el servicio de membresía

class PagosScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId; // Añadimos el _id de la membresía

  const PagosScreen({super.key, required this.token, required this.user, required this.membresiaId});

  @override
  _PagosScreenState createState() => _PagosScreenState();
}

class _PagosScreenState extends State<PagosScreen> {
  DateTime? _expiryDate;
  bool isLoading = true;
  List<dynamic> planes = [];
  late datosMembresia _datosMembresia;
  late listaPlanes _listaPlanes;
  Map<String, dynamic>? _membresiaData;

  @override
  void initState() {
    super.initState();
    _datosMembresia = datosMembresia(token: widget.token, membresiaId: widget.membresiaId);
    _listaPlanes = listaPlanes(token: widget.token, membresiaId: widget.membresiaId);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final membresiaData = await _datosMembresia.fetchMembresiaData();
      final planesData = await _listaPlanes.fetchPlanData();

      setState(() {
        _membresiaData = membresiaData;
        planes = planesData;
        _expiryDate = DateTime.parse(membresiaData['fecha_fin']);
        isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Función que maneja el ID del plan seleccionado
  void _seleccionarPlan(String planId) {
    final planSeleccionado = planes.firstWhere((plan) => plan['_id'] == planId, orElse: () => null);

    if (planSeleccionado != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmacionScreen(token: widget.token, plan: planSeleccionado, membresiaId: widget.membresiaId,),
        ),
      );
    } else {
      print('No se encontró el plan seleccionado');
    }
  }

  // Mostrar modal de membresías con tarjetas centradas y scroll
  void _showPlanesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Fondo transparente para aplicar blur
      isScrollControlled: true, // Permite que el modal ocupe más espacio
      builder: (BuildContext context) {
        return PlanesModal(
          planes: planes,
          onPlanSelected: _seleccionarPlan,
        );
      },
    );
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding ajustado
                child: Column(
                  children: [
                    Text(
                      'Consulta tus pagos y renueva tu membresía fácilmente.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                    if (_membresiaData != null && _expiryDate != null)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Plan de membresía:',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _membresiaData!['nombrePlan'] ?? 'Plan no disponible',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Estado: Activa',
                              style: TextStyle(fontSize: 16, color: Colors.green),
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _showPlanesModal(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple, // Color del botón
                                      padding: EdgeInsets.symmetric(vertical: 12), // Padding interno
                                    ),
                                    child: Text('Renovar Membresía', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                SizedBox(width: 8), // Espacio entre botones
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Lógica para cancelar membresía
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // Color del botón
                                      padding: EdgeInsets.symmetric(vertical: 12), // Padding interno
                                    ),
                                    child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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