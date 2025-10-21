import 'package:flutter/material.dart';

class PagarUiBuilders {
  /// Placeholder para tarjeta
  static Widget buildPlaceholderTarjeta() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Text(
      'Aquí va el formulario de tarjeta',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600]),
    ),
  );
}

  /// Placeholder para efectivo
  static Widget buildPlaceholderEfectivo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Column(
          children: [
            Icon(Icons.payments, size: 48, color: Colors.green[700]),
            const SizedBox(height: 12),
            Text(
              'Pago contra entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green[900],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pagarás en efectivo al recibir tu pedido',
              style: TextStyle(
                fontSize: 13,
                color: Colors.green[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de error
  static Widget buildError({
    required String errorMessage,
    required VoidCallback onReintentar,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget de loading
  static Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Color(0xFF2196F3)),
    );
  }
}