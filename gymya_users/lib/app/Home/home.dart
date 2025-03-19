import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Importación del paquete
import 'package:gymya_users/app/funciones/datosMembresia.dart';
import 'package:gymya_users/app/funciones/ultimaEntrada.dart';
import 'package:gymya_users/app/Home/widgets/header.dart';
import 'package:gymya_users/app/Home/widgets/membership_card.dart';
import 'package:gymya_users/app/Home/widgets/visit_card.dart';
import 'package:gymya_users/app/Home/widgets/calendar.dart';
import 'package:gymya_users/app/Home/widgets/qr_code.dart';
import 'package:gymya_users/app/Asistencias/historial_entradas.dart';
//import 'package:gymya_users/app/Entrenadores/entrenadores.dart';
import 'package:gymya_users/app/horarios_gym/horariosgym.dart';
import 'package:gymya_users/app/Pagos/pagos.dart';
import 'package:gymya_users/app/Pagos/confirmacion.dart'; // pantalla de confirmación
import 'dart:ui';

class DashboardScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final String membresiaId;

  const DashboardScreen({super.key, required this.token, required this.user, required this.membresiaId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime? _expiryDate;
  String? _planId;
  bool isLoading = true;
  bool showQRCode = false;
  late datosMembresia _datosMembresia;
  late UltimaEntrada _ultimaEntrada;
  Map<String, dynamic>? _membresiaData;
  Map<String, dynamic>? _ultimaEntradaData;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _datosMembresia = datosMembresia(token: widget.token, membresiaId: widget.membresiaId);
    _ultimaEntrada = UltimaEntrada(token: widget.token, membresiaId: widget.membresiaId);
    _loadData();

    _screens.addAll([
      //EntrenadoresScreen(token: widget.token, user: widget.user, membresiaId: widget.membresiaId),
      HorariosScreen(token: widget.token, user: widget.user, membresiaId: widget.membresiaId),
      PagosScreen(token: widget.token, user: widget.user, membresiaId: widget.membresiaId),
    ]);
  }

  Future<void> _loadData() async {
    try {
      // Cargar datos de membresía
      final membresiaData = await _datosMembresia.fetchMembresiaData();
      setState(() {
        _membresiaData = membresiaData;
        _expiryDate = DateTime.parse(membresiaData['fecha_fin']);
        _planId = membresiaData['plan_id']; // Extraer el planId de los datos de la membresía
      });
    } catch (error) {
      print('Error al obtener datos de membresía: $error');
      setState(() {
        _membresiaData = {'nombrePlan': 'Plan no disponible', 'fecha_fin': DateTime.now().toString()};
        _expiryDate = DateTime.now();
        _planId = null; // Asegúrate de que _planId sea nulo en caso de error
      });
    }

    try {
      // Cargar datos de la última entrada
      final ultimaEntradaData = await _ultimaEntrada.fetchUltimaEntrada();
      setState(() {
        _ultimaEntradaData = ultimaEntradaData['data'];
      });
    } catch (error) {
      print('Error al obtener la última entrada: $error');
      setState(() {
        _ultimaEntradaData = {
          'fecha_hora': 'Aún no hay visitas',
          'gimnasioNombre': 'el gimnasio',
        };
      });
    }

    // Finalmente, deshabilitar el indicador de carga
    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleQRCode() {
    setState(() {
      showQRCode = !showQRCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.purple));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      Header(user: widget.user, token: widget.token),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Estado de membresía:',
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                        const Text(
                                          'Manten tu membresía activa.',
                                          style: TextStyle(color: Colors.white60, fontSize: 14),
                                        ),
                                        const SizedBox(height: 12),
                                        if (_membresiaData != null && _expiryDate != null)
                                          MembershipCard(
                                            nombrePlan: _membresiaData!['nombrePlan'] ?? 'Plan no disponible',
                                            expiryDate: _expiryDate!,
                                            onConfirmacionPressed: () {
                                              if (_planId == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Error: No se pudo obtener el ID del plan.')),
                                                );
                                                return;
                                              }

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ConfirmacionScreen(
                                                    token: widget.token,
                                                    planId: _planId!, // Pasamos solo el planId
                                                    membresiaId: widget.membresiaId,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Asistencias:',
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                        ),
                                        const Text(
                                          'Consulta tu código QR e historial de asistencias.',
                                          style: TextStyle(color: Colors.white60, fontSize: 14),
                                        ),
                                        const SizedBox(height: 12),
                                        VisitCard(
                                          ultimaVisita: _ultimaEntradaData != null && _ultimaEntradaData!['fecha_hora'] != null
                                              ? _ultimaEntradaData!['fecha_hora']
                                              : 'Aún no hay visitas',
                                          nombreGym: _ultimaEntradaData != null && _ultimaEntradaData!['gimnasioNombre'] != null
                                              ? _ultimaEntradaData!['gimnasioNombre']
                                              : 'el gimnasio',
                                          onEnterPressed: _toggleQRCode,
                                          onHistoryPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HistorialEntradasScreen(
                                                  token: widget.token,
                                                  user: widget.user,
                                                  membresiaId: widget.membresiaId,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estado de membresía:',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  const Text(
                                    'Manten tu membresía activa.',
                                    style: TextStyle(color: Colors.white60, fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  if (_membresiaData != null && _expiryDate != null)
                                    MembershipCard(
                                      nombrePlan: _membresiaData!['nombrePlan'] ?? 'Plan no disponible',
                                      expiryDate: _expiryDate!,
                                      onConfirmacionPressed: () {
                                        if (_planId == null) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error: No se pudo obtener el ID del plan.')),
                                          );
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ConfirmacionScreen(
                                              token: widget.token,
                                              planId: _planId!, // Pasamos solo el planId
                                              membresiaId: widget.membresiaId,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Asistencias:',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  const Text(
                                    'Consulta tu código QR e historial de asistencias.',
                                    style: TextStyle(color: Colors.white60, fontSize: 14),
                                  ),
                                  const SizedBox(height: 12),
                                  VisitCard(
                                    ultimaVisita: _ultimaEntradaData != null && _ultimaEntradaData!['fecha_hora_entrada'] != null
                                        ? _ultimaEntradaData!['fecha_hora_entrada']
                                        : 'Aún no hay visitas',
                                    nombreGym: _ultimaEntradaData != null && _ultimaEntradaData!['gimnasioNombre'] != null
                                        ? _ultimaEntradaData!['gimnasioNombre']
                                        : 'el gimnasio',
                                    onEnterPressed: _toggleQRCode,
                                    onHistoryPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistorialEntradasScreen(
                                            token: widget.token,
                                            user: widget.user,
                                            membresiaId: widget.membresiaId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                      CustomCalendar(
                        calendarFormat: _calendarFormat,
                        focusedDay: _focusedDay,
                        selectedDay: _selectedDay,
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ],
                  ),
                ),
                ..._screens,
              ],
            ),
          ),
          if (showQRCode)
            GestureDetector(
              onTap: _toggleQRCode,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: QRCodeWidget(
                        membresiaId: widget.membresiaId,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

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
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        /*
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Couch',
        ), */
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Horarios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          label: 'Pagos',
        ),
      ],
    );
  }
}