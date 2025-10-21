import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/metodo_pago_widget.dart';
import 'widgets/resumen_productos_widget.dart';
import 'widgets/total_pago_widget.dart';
import 'package:ihc_inscripciones/page/qr/widgets/qr_contenido_widget.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

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
  List<Map<String, dynamic>> productos = [];
  Map<String, dynamic> resumen = {};
  String? metodoSeleccionado;
  bool isLoading = true;
  bool procesando = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  /// Cargar datos desde pagar.json y combinar con datos del carrito
  Future<void> cargarDatos() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Cargar métodos de pago desde JSON
      final jsonString = await rootBundle.loadString(
        'lib/page/pagar/data/pagar.json',
      );
      final data = json.decode(jsonString);

      // Si hay datos del carrito, usarlos; sino usar datos del JSON
      if (widget.itemsCarrito != null && widget.itemsCarrito!.isNotEmpty) {
        // Convertir items del carrito a formato de productos para resumen
        productos = widget.itemsCarrito!.map((item) {
          return {
            'nombre': item['producto']['nombre'],
            'precio': (item['producto']['precio'] as num).toDouble() *
                (item['cantidad'] as int),
          };
        }).toList();

        // Usar resumen del carrito
        resumen = {
          'productos': productos,
          'descuentos': widget.resumenCarrito?['descuentos'] ?? 0.0,
          'costoEnvio': 0.0,
          'subtotal': widget.resumenCarrito?['subtotal'] ?? 0.0,
          'total': widget.resumenCarrito?['total'] ?? 0.0,
        };
      } else {
        // Usar datos de ejemplo del JSON si no hay carrito
        resumen = data['resumen'] ?? {};
        productos = List<Map<String, dynamic>>.from(resumen['productos'] ?? []);
      }

      setState(() {
        metodosPago = List<Map<String, dynamic>>.from(
          data['metodosPago'] ?? [],
        );

        // Seleccionar primer método por defecto
        if (metodosPago.isNotEmpty) {
          metodoSeleccionado = metodosPago[0]['id'];
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar datos: $e';
      });
      debugPrint('Error cargando datos: $e');
    }
  }

  /// Seleccionar método de pago
  void seleccionarMetodo(String metodoId) {
    setState(() {
      metodoSeleccionado = metodoId;
    });
  }

  /// Confirmar pago
  void confirmarPago() async {
    if (metodoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un método de pago'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    setState(() {
      procesando = true;
    });

    // Simular procesamiento
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      procesando = false;
    });

    // Navegar según el método seleccionado
    if (!mounted) return;

    switch (metodoSeleccionado) {
      case 'qr':
        // Para QR, no necesitamos navegar porque ya se muestra en la misma página
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Pago procesado con éxito!'),
            backgroundColor: Color(0xFF4CAF50),
            duration: Duration(seconds: 2),
          ),
        );
        // Navegar al home o tracking después de confirmar
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }
        });
        break;
      case 'tarjeta':
        Navigator.pushNamed(context, AppRoutes.tarjeta);
        break;
      case 'efectivo':
        // Mostrar confirmación para efectivo
        _mostrarConfirmacionEfectivo();
        break;
    }
  }

  /// Mostrar diálogo de confirmación para efectivo
  void _mostrarConfirmacionEfectivo() {
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
              Navigator.pop(context); // Cerrar diálogo
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      body: _buildBody(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TotalPagoWidget(
            onConfirmar: confirmarPago,
            procesando: procesando,
          ),
          const BarraInferior(indiceActual: 1),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2196F3)),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: cargarDatos,
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

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Métodos de pago
          MetodoPagoWidget(
            metodos: metodosPago,
            metodoSeleccionado: metodoSeleccionado,
            onMetodoSeleccionado: seleccionarMetodo,
          ),

          const SizedBox(height: 24),

          // Contenido dinámico según método seleccionado
          if (metodoSeleccionado == 'qr')
            QrContenidoWidget(
              total: (resumen['total'] ?? 0.0) is int
                  ? (resumen['total'] as int).toDouble()
                  : (resumen['total'] ?? 0.0) as double,
            ),

          if (metodoSeleccionado == 'tarjeta')
            _buildPlaceholderTarjeta(),

          if (metodoSeleccionado == 'efectivo')
            _buildPlaceholderEfectivo(),

          const SizedBox(height: 24),

          // Ubicación (siempre visible)
          _buildUbicacion(),

          const SizedBox(height: 24),

          // Resumen de productos (siempre visible)
          ResumenProductosWidget(
            productos: productos,
            descuentos: (resumen['descuentos'] ?? 0.0) is int
                ? (resumen['descuentos'] as int).toDouble()
                : (resumen['descuentos'] ?? 0.0) as double,
            costoEnvio: (resumen['costoEnvio'] ?? 0.0) is int
                ? (resumen['costoEnvio'] as int).toDouble()
                : (resumen['costoEnvio'] ?? 0.0) as double,
            total: (resumen['total'] ?? 0.0) is int
                ? (resumen['total'] as int).toDouble()
                : (resumen['total'] ?? 0.0) as double,
          ),

          const SizedBox(height: 100), // Espacio para el bottom
        ],
      ),
    );
  }

  Widget _buildUbicacion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubicación >',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Calle Principal #123',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'La Paz, Bolivia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.edit, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
//para pagar con targeta, llamar logica
  Widget _buildPlaceholderTarjeta() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(Icons.credit_card, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              'Formulario de tarjeta',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Próximamente',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderEfectivo() {
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
}