import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrContenidoWidget extends StatelessWidget {
  final double total;
  final String? ordenId;

  const QrContenidoWidget({super.key, required this.total, this.ordenId});

  String _generarOrdenId() {
    return ordenId ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generarDataQr() {
    final id = _generarOrdenId();
    return 'GLOBY:$id:${total.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Contenedor del QR
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: _generarDataQr(),
              version: QrVersions.auto,
              size: 220.0,
              backgroundColor: Colors.white,
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),

          const SizedBox(height: 24),

          // Instrucción principal
          const Text(
            'Escanea el código para pagar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
