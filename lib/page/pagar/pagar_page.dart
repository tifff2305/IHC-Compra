import 'package:flutter/material.dart';
import 'widgets/metodo_pago_widget.dart';
import 'widgets/resumen_productos_widget.dart';
import 'widgets/contenido_metodo_widget.dart';
import 'widgets/ubicacion_widget.dart';
import 'widgets/total_pago_widget.dart';
import 'metodos/pagar_metodos.dart';
import 'metodos/pagar_ui_builders.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';

class PagarPage extends StatefulWidget {
  final List<dynamic>? itemsCarrito; 
  final Map<String, dynamic>? resumenCarrito;

  const PagarPage({
    Key? key,
    this.itemsCarrito, 
    this.resumenCarrito,
  }) : super(key: key);

  @override
  State<PagarPage> createState() => _PagarPageState();
}

class _PagarPageState extends State<PagarPage> {
  List<Map<String, dynamic>> metodosPago = [];
  String metodoSeleccionado = 'qr'; // Siempre inicia en QR
  bool isLoading = true;
  bool procesando = false;
  String? errorMessage;

  // Ubicación de entrega
  String direccion = 'Calle Principal #123';
  String ciudad = 'La Paz, Bolivia';

  @override
  void initState() {
    super.initState();
    _cargarMetodosPago();
  }

  /// Cargar solo los métodos de pago disponibles
  Future<void> _cargarMetodosPago() async {
    try {
      setState(() => isLoading = true);
      metodosPago = await PagarMetodos.cargarMetodosPago();
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar métodos de pago';
      });
    }
  }

  /// Convertir a lista de productos para ResumenWidget
  List<Map<String, dynamic>> get productos {
    return (widget.itemsCarrito ?? []).map((item) {
      // ← Agregar ?? []
      return {
        'nombre': item['producto']['nombre'],
        'precio':
            (item['producto']['precio'] as num).toDouble() *
            (item['cantidad'] as int),
      };
    }).toList();
  }

  double get total =>
      ((widget.resumenCarrito ?? {})['total'] ?? 0.0)
              is int // ← Agregar ?? {}
          ? ((widget.resumenCarrito ?? {})['total'] as int).toDouble()
          : ((widget.resumenCarrito ?? {})['total'] ?? 0.0) as double;

  double get descuentos =>
      ((widget.resumenCarrito ?? {})['descuentos'] ?? 0.0)
              is int // ← Agregar ?? {}
          ? ((widget.resumenCarrito ?? {})['descuentos'] as int).toDouble()
          : ((widget.resumenCarrito ?? {})['descuentos'] ?? 0.0) as double;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BarraSuperior(),
      body:
          isLoading
              ? PagarUiBuilders.buildLoading()
              : errorMessage != null
              ? PagarUiBuilders.buildError(
                errorMessage: errorMessage!,
                onReintentar: _cargarMetodosPago,
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Métodos de pago
                    MetodoPagoWidget(
                      metodos: metodosPago,
                      metodoSeleccionado: metodoSeleccionado,
                      onMetodoSeleccionado:
                          (id) => setState(() => metodoSeleccionado = id),
                    ),

                    const SizedBox(height: 24),

                    // Contenido dinámico según método
                    ContenidoMetodoWidget(
                      metodoSeleccionado: metodoSeleccionado,
                      total: total,
                    ),

                    const SizedBox(height: 24),

                    // Ubicación
                    UbicacionWidget(
                      direccion: direccion,
                      ciudad: ciudad,
                      onUbicacionCambiada: () => setState(() {}),
                    ),

                    const SizedBox(height: 24),

                    // Resumen
                    ResumenProductosWidget(
                      productos: productos,
                      descuentos: descuentos,
                      costoEnvio: 0.0,
                      total: total,
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TotalPagoWidget(
            onConfirmar: () async {
              setState(() => procesando = true);
              await PagarMetodos.confirmarPago(
                context: context,
                metodoSeleccionado: metodoSeleccionado,
                total: total,
              );
              if (mounted) setState(() => procesando = false);
            },
            procesando: procesando,
          ),
          const BarraInferior(indiceActual: 1),
        ],
      ),
    );
  }
}
