import 'package:flutter/material.dart';
import 'package:gymya_users/app/Pagos/widgets/header_confirmacion.dart';
import 'package:gymya_users/app/Pagos/widgets/plan_card.dart';
import 'package:gymya_users/app/Funciones/aplazarMembresia.dart';
import 'package:gymya_users/app/Funciones/planIndividual.dart';

class ConfirmacionScreen extends StatefulWidget {
  final String token;
  final String planId; // Ahora solo necesitamos el planId
  final String membresiaId;
  final String metodoPago;

  const ConfirmacionScreen({
    super.key,
    required this.token,
    required this.planId,
    required this.membresiaId,
    this.metodoPago = 'Tarjeta de crédito',
  });

  @override
  _ConfirmacionScreenState createState() => _ConfirmacionScreenState();
}

class _ConfirmacionScreenState extends State<ConfirmacionScreen> {
  Map<String, dynamic>? _planData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlanData();
  }

  Future<void> _fetchPlanData() async {
    try {
      final planIndividual = Planindividual(token: widget.token, planId: widget.planId);
      final planData = await planIndividual.fetchPlanData();
      setState(() {
        _planData = planData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al obtener los datos del plan: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los datos del plan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gimnasios = _planData?['gimnasios'] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(onBackPressed: () {
            Navigator.pop(context);
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.purple))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_planData != null)
                            PlanDetailsCard(
                              plan: _planData!,
                              metodoPago: widget.metodoPago,
                              gimnasios: gimnasios,
                            ),
                          SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  final aplazamiento = Aplazarmembresia(
                                    token: widget.token,
                                    membresiaId: widget.membresiaId,
                                    planId: widget.planId,
                                  );

                                  final resultado = await aplazamiento.aplazar();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Membresía aplazada: ${resultado['message']}'),
                                  ));

                                  Navigator.pop(context);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al aplazar la membresía: $e')),
                                  );
                                }
                              },
                              child: Text(
                                'Confirmar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
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