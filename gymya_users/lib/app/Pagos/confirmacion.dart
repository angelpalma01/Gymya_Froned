import 'package:flutter/material.dart';
import 'package:gymya_users/app/Pagos/widgets/header_confirmacion.dart'; // Importamos el header personalizado
import 'package:gymya_users/app/Pagos/widgets/plan_card.dart'; // Importamos la nueva tarjeta de detalles
import 'package:gymya_users/app/Funciones/aplazarMembresia.dart'; // Importamos la nueva tarjeta de detalles

class ConfirmacionScreen extends StatelessWidget {
  final String token;
  final Map<String, dynamic> plan;
  final String membresiaId; // Añadimos el _id de la membresía
  final String metodoPago; // Método de pago estático por ahora

  ConfirmacionScreen({super.key, required this.token, required this.plan, required this.membresiaId, this.metodoPago = 'Tarjeta de crédito'});

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
                        onPressed: () async {
                          try {
                            // Crear una instancia de Aplazarmembresia
                            final aplazamiento = Aplazarmembresia(
                              token: token,
                              membresiaId: membresiaId,
                              planId: plan['_id'], // Usar el _id del plan
                            );

                            // Realizar la solicitud
                            final resultado = await aplazamiento.aplazar();

                            // Mostrar mensaje de éxito
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Membresía aplazada: ${resultado['message']}')),
                            );

                            // Regresar a la pantalla anterior o donde necesites
                            Navigator.pop(context);
                          } catch (e) {
                            // Mostrar mensaje de error
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