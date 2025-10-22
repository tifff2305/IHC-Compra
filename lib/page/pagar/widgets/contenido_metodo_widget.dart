import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/qr/widgets/qr_contenido_widget.dart';
import 'package:ihc_inscripciones/page/tarjeta/widgets/tarjeta_widget.dart';
import '../metodos/pagar_ui_builders.dart';

/// Widget que muestra contenido específico según el método de pago seleccionado
/// Cambia dinámicamente entre QR, tarjeta o efectivo
class ContenidoMetodoWidget extends StatelessWidget {
  final String? metodoSeleccionado;
  final double total;

  const ContenidoMetodoWidget({
    super.key,
    required this.metodoSeleccionado,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    switch (metodoSeleccionado) {
      case 'qr':
        return QrContenidoWidget(total: total);
      
      case 'tarjeta':
        // return PagarUiBuilders.buildPlaceholderTarjeta(); //aca va el widget de tarjeta o tu pagina el benjas, solo llamalo aca 
        return TarjetaWidget();
      
      case 'efectivo':
        return PagarUiBuilders.buildPlaceholderEfectivo();
      
      default:
        return const SizedBox.shrink();
    }
  }
}