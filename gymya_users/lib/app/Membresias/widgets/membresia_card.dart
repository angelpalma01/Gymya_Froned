import 'package:flutter/material.dart';
import 'package:gymya_users/app/funciones/formatearFecha.dart';
import 'package:gymya_users/app/funciones/estadoMembresia.dart';

class MembresiaCard extends StatefulWidget {
  final Map<String, dynamic> membresia;
  final VoidCallback onTap;

  const MembresiaCard({required this.membresia, required this.onTap, super.key});

  @override
  _MembresiaCardState createState() => _MembresiaCardState();
}

class _MembresiaCardState extends State<MembresiaCard> {
  bool _isPressed = false; // Estado para controlar si la tarjeta está presionada

  @override
  Widget build(BuildContext context) {
    final fechaFin = DateTime.parse(widget.membresia['fecha_fin']);
    final estado = getMembresiaStatus(fechaFin);
    final colorEstado = getColorEstado(estado);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
      child: InkWell(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _isPressed = true), // Cambia el estado al presionar
        onTapCancel: () => setState(() => _isPressed = false), // Restablece el estado al cancelar
        onTapUp: (_) => setState(() => _isPressed = false), // Restablece el estado al soltar
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: _isPressed ? Colors.purple : Colors.grey[900], // Cambia el color si está presionada
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.membresia['nombre_plan'] ?? 'Nombre no disponible',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Acceso a: ${widget.membresia['gimnasios'].join(', ')}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                'Disponible hasta: ${formatFecha(fechaFin)}',
                style: TextStyle(color: Colors.white60),
              ),
              SizedBox(height: 4),
              Text(
                'Estado: $estado',
                style: TextStyle(
                  color: colorEstado,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}