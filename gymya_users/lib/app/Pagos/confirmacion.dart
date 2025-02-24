import 'package:flutter/material.dart';
import 'package:gymya_users/app/Pagos/widgets/header_confirmacion.dart'; // Importamos el header personalizado
import 'package:gymya_users/app/Pagos/widgets/plan_card.dart'; // Importamos la nueva tarjeta de detalles

class ConfirmacionScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> plan;
  final String metodoPago; // Método de pago estático por ahora

  ConfirmacionScreen({super.key, required this.token, required this.plan, this.metodoPago = 'Tarjeta de crédito'});

  @override
  Widget build(BuildContext context) {
    final gimnasios = plan['gimnasios'] ?? []; // Lista de gimnasios que el plan cubre

    return Scaffold(
      backgroundColor: Colors.black, // Fondo negro
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(onBackPressed: () {
            Navigator.pop(context);
          }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView( // Para permitir scroll si el contenido es extenso
                child: Column(
                  children: [
                    PlanDetailsCard(
                      plan: plan,
                      metodoPago: metodoPago,
                      gimnasios: gimnasios,
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Lógica para confirmar el pago
                          print('Pago confirmado para el plan ${plan['nombre']}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Pago confirmado para el plan ${plan['nombre']}')),
                          );
                          // Regresar a la pantalla anterior o donde necesites
                          Navigator.pop(context);
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
                          backgroundColor: Colors.purple, // Color del botón
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
