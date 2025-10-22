import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

class PagarMetodos {
  /// Cargar solo los métodos de pago disponibles
  static Future<List<Map<String, dynamic>>> cargarMetodosPago() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/page/pagar/data/pagar.json',
      );
      final data = json.decode(jsonString);
      return List<Map<String, dynamic>>.from(data['metodosPago'] ?? []);
    } catch (e) {
      debugPrint('Error cargando métodos de pago: $e');
      rethrow;
    }
  }

  /// Confirmar pago según método seleccionado
  static Future<void> confirmarPago({
    required BuildContext context,
    required String metodoSeleccionado,
    required double total,
  }) async {
    switch (metodoSeleccionado) {
      case 'qr':
        _procesarPagoQr(context);
        break;
      /* case 'tarjeta':
        await avegarATarjeta(context, total);
        break; */
      case 'efectivo':
        _procesarPagoEfectivo(context);
        break;
    }
  }

  /// Procesar pago con QR
  static void _procesarPagoQr(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Pago procesado con éxito!'),
        backgroundColor: Color(0xFF4CAF50),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.tracking);
      }
    });
  }

  

  /// Procesar pago en efectivo
  static void _procesarPagoEfectivo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pago en Efectivo'),
        content: const Text(
          'Tu pedido ha sido confirmado. Pagarás en efectivo al recibir tu orden.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}