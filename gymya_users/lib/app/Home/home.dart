// este aparatdo es el home y dashboard_screen

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:barcode_widget/barcode_widget.dart'; // Para generar el código QR
import 'dart:convert';
import 'dart:ui'; // Importa ImageFilter para el efecto de blur

class DashboardScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const DashboardScreen({super.key, required this.token, required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime? _expiryDate;
  String? _membresiaId;
  String? _planId;
  bool isLoading = true;
  bool showQRCode = false; // Nuevo estado para controlar la visibilidad del QR

  // Endpoint de membresía
  final String membresiaUrl = 'https://api-gymya-api.onrender.com/api/membresia';

  @override
  void initState() {
    super.initState();
    _fetchMembresiaData();
  }

  Future<void> _fetchMembresiaData() async {
    try {
      final response = await http.get(
        Uri.parse(membresiaUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Pasa el token en la cabecera
        },
      );

      if (response.statusCode == 200) {
        // Parsear los datos de la respuesta
        final List<dynamic> data = jsonDecode(response.body); // Parseamos la respuesta como lista

        if (data.isNotEmpty) {
        final membresia = data[0]; // Accedemos al primer elemento de la lista

        setState(() {
          _expiryDate = DateTime.parse(membresia['fecha_fin']); // Fecha de fin de la membresía
          _membresiaId = membresia['membresia_id'].toString(); // ID de la membresía
          _planId = membresia['plan_id'].toString(); // ID del plan
          isLoading = false;
        });
        } else {
          throw Exception('No se encontraron datos de membresía');
        }
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Contenido principal
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Estado de membresía:'),
                        const Text(
                          'Mantén tu membresía activa para seguir disfrutando de los beneficios.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        _buildMembershipCard(), // Fecha fin de la membresía
                        const SizedBox(height: 16),
                        const SectionTitle(title: 'Entrada al gimnasio:'),
                        const Text(
                          'Escanea el código QR para acceder al gimnasio.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        VisitCard(
                          lastVisitDate: 'Última visita: 12 de Octubre 2023',
                          onEnterPressed: _toggleQRCode,
                          onHistoryPressed: () {
                            // Aquí puedes agregar la lógica para ver el historial
                          },
                        ),
                        const SizedBox(height: 16),
                        const SectionTitle(title: 'Calendario:'),
                        _buildCalendar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Efecto de blur y código QR
          if (showQRCode)
            GestureDetector(
              onTap: _toggleQRCode, // Cierra el código QR al tocar fuera de él
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Efecto de desenfoque
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Fondo semi-transparente
                  child: Center(
                    child: GestureDetector(
                      onTap: () {}, // Evita que el toque en el QR lo cierre
                      child: _buildQRCode(), // Código QR centrado
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

  Widget _buildQRCode() {
    // Verifica si ya tenemos los datos de la membresía y genera el QR
    if (_membresiaId != null && _planId != null && _expiryDate != null) {
      final qrData = {
        'membresia_id': _membresiaId,
        'plan_id': _planId,
        'fecha_fin': _expiryDate!.toIso8601String(),
      };

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: BarcodeWidget(
          barcode: Barcode.qrCode(), // Convertimos los datos del QR a un JSON
          data: jsonEncode(qrData),
          width: 200,
          height: 200,
          backgroundColor: Colors.white,  // Fondo blanco para el QR
          color: Colors.black,  // Color del código QR
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Cargando datos de membresía...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildMembershipCard() {
    // Verificar si la fecha de expiración no es null
    String expiryDateString = _expiryDate != null
        ? DateFormat('dd MMMM yyyy').format(_expiryDate!) // Formatear fecha
        : 'No disponible';

    return MembershipCard(expiryDate: expiryDateString);
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.purple, Colors.red],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds);
            },
            child: Text(
              'Hola, ${widget.user['nombre_completo']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const CircleAvatar(
            radius: 24,
            //backgroundImage: AssetImage('assets/profile_picture.png'),
          ),
        ],
      ),
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Couch'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horarios'),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
      ],
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
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
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.purple,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.white),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }
}

class MembershipCard extends StatelessWidget {
  final String expiryDate;

  const MembershipCard({required this.expiryDate, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fecha de vencimiento:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            expiryDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: const Text('Pagar ahora', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class VisitCard extends StatelessWidget {
  final String lastVisitDate;
  final VoidCallback onEnterPressed;
  final VoidCallback onHistoryPressed;

  const VisitCard({
    required this.lastVisitDate,
    required this.onEnterPressed,
    required this.onHistoryPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Última visita:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            lastVisitDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onEnterPressed,
                child: Text(
                  'Entrada al gym',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 101, 9, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onHistoryPressed,
                child: const Text('Ver Historial', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}