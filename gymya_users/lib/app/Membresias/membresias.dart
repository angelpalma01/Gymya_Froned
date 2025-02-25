import 'package:flutter/material.dart';
import 'package:gymya_users/app/funciones/listaMembresias.dart';
import 'package:gymya_users/app/Home/home.dart';
import 'package:gymya_users/app/Membresias/widgets/membresia_card.dart';
import 'package:gymya_users/app/Membresias/widgets/header.dart'; // Importa el nuevo header

class MembresiasList extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;

  const MembresiasList({super.key, required this.token, required this.user});

  @override
  _MembresiasListState createState() => _MembresiasListState();
}

class _MembresiasListState extends State<MembresiasList> {
  List<dynamic> membresias = [];
  bool isLoading = true;
  late listaMembresias _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = listaMembresias(token: widget.token);
    fetchMembresias();
  }

  Future<void> fetchMembresias() async {
    try {
      final data = await _apiService.fetchMembresias();
      setState(() {
        membresias = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void goToNextScreen(String membresiaId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          token: widget.token,
          user: widget.user,
          membresiaId: membresiaId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          const Header(), // Usa el nuevo header sin parámetros
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.purple))
                : ListView.builder(
                    itemCount: membresias.length,
                    itemBuilder: (context, index) {
                      final membresia = membresias[index];
                      return MembresiaCard(
                        membresia: membresia,
                        onTap: () => goToNextScreen(membresia['membresia_id']),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}