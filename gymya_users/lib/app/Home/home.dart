import 'package:flutter/material.dart';
import 'package:gymya_users/app/historial/historial_entradas.dart';

class DashboardScreen extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const DashboardScreen({super.key, required this.token, required this.user});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                padding: const EdgeInsets.all(16.0),
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
                      onEnterPressed: () {},
                      onHistoryPressed: () {
                      Navigator.push(
                       context,
                       MaterialPageRoute(
                       builder: (context) => HistorialEntradasScreen(
                       token: widget.token,
                        user: widget.user, // Asegúrate de pasar el usuario también
                          ),
                        ),
                      );
                    },
                    ),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, ${widget.user['nombre_completo']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Entrenadores'),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horarios'),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pagos'),
      ],
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
      style: const TextStyle(color: Colors.black, fontSize: 18),
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
        color: Colors.white,
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
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            expiryDate,
            style: const TextStyle(
              color: Colors.black,
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
        color: Colors.white,
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
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Text(
            lastVisitDate,
            style: const TextStyle(
              color: Colors.black,
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
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onEnterPressed,
                child: const Text('Entrada al gym', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
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
