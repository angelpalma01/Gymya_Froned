import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gymya_users/app/historial/historial_entradas.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Para decodificar JSON

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
  Future<String>? _qrFuture; // Variable para manejar la llamada de la API que genera el QR

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Método para generar el QR mediante una petición HTTP
  Future<String> generarQR() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-gymya-api.onrender.com/api/user/qr'), // Cambia la URL por la de tu API
        headers: {
          'Authorization': 'Bearer ${widget.token}',  // Enviar el token en la cabecera
        },
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['qrCode'];  // Aquí se devuelve el valor en Base64 del QR
      } else {
        throw Exception('Error al generar el código QR');
      }
    } catch (error) {
      throw Exception('Error al conectar con la API: $error');
    }
  }

  // Método para iniciar la generación del QR
  void _onEnterPressed() {
    setState(() {
      _qrFuture = generarQR();  // Asignar la llamada a la API cuando se presiona el botón
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                    MembershipCard(expiryDate: '25 noviembre 2024'),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Entrada al gimnasio:'),
                    const Text(
                      'Escanea el código QR para acceder al gimnasio y observa tu historial de visitas.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    VisitCard(
                      lastVisitDate: '23 noviembre 2024',
                      onEnterPressed: _onEnterPressed,
                      onHistoryPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistorialEntradasScreen(
                              token: widget.token,
                              user: widget.user,
                            ),
                          ),
                        );
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
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
            backgroundImage: AssetImage('assets/profile_picture.png'),
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