import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'dart:convert';

class QRCodeWidget extends StatelessWidget {
  final String membresiaId;
  final String planId;

  const QRCodeWidget({required this.membresiaId, required this.planId, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: jsonEncode({
          'membresia_id': membresiaId,
          'plan_id': planId,
        }),
        width: 200,
        height: 200,
        backgroundColor: Colors.white,
        color: Colors.black,
      ),
    );
  }
}