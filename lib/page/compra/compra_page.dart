import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/compra_item_widget.dart';
import 'widgets/compra_resumen_widget.dart';
import 'widgets/compra_empty_widget.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/page/pagar/pagar_page.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

class CompraPage extends StatefulWidget {
  const CompraPage({Key? key}) : super(key: key);

  @override
  State<CompraPage> createState() => _CompraPageState();
}

class _CompraPageState extends State<CompraPage> {
  List<dynamic> items = [];
  Map<String, dynamic> resumen = {
    'subtotal': 0.0,
    'descuentos': 0.0,
    'total': 0.0,
    'cantidadItems': 0,
    'cantidadProductos': 0,
  };
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    cargarCarrito();
  }

  /// Cargar datos del carrito desde compra.json
  Future<void> cargarCarrito() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final jsonString = await rootBundle.loadString(
        'lib/page/compra/data/compra.json',
      );
      final data = json.decode(jsonString);

      setState(() {
        items = data['items'] ?? [];
        resumen = data['resumen'] ?? resumen;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error al cargar el carrito: $e';
      });
      debugPrint('Error cargando carrito: $e');
    }
  }

  /// Actualizar cantidad de un item
  void actualizarCantidad(String itemId, int nuevaCantidad) {
    if (nuevaCantidad < 1) return;

    setState(() {
      final index = items.indexWhere((item) => item['id'] == itemId);
      if (index != -1) {
        final item = items[index];
        final precioUnitario = (item['producto']['precio'] as num).toDouble();

        // Actualizar cantidad y subtotal
        items[index]['cantidad'] = nuevaCantidad;
        items[index]['subtotal'] = precioUnitario * nuevaCantidad;

        // Recalcular totales
        calcularTotales();
      }
    });

    // Aquí deberías guardar en compra.json
    // guardarCarrito();
  }

  /// Eliminar un item del carrito
  void eliminarItem(String itemId) {
    setState(() {
      items.removeWhere((item) => item['id'] == itemId);
      calcularTotales();
    });

    // Aquí deberías guardar en compra.json
    // guardarCarrito();

    // Mostrar mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Producto eliminado del carrito'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  /// Calcular totales del carrito
  void calcularTotales() {
    double subtotal = 0.0;
    double descuentos = 0.0;
    int cantidadItems = 0;

    for (var item in items) {
      final cantidad = (item['cantidad'] as int);
      final precio = (item['producto']['precio'] as num).toDouble();
      final precioAnterior = item['producto']['precioAnterior'];

      subtotal += precio * cantidad;
      cantidadItems += cantidad;

      // Calcular descuento si existe precioAnterior
      if (precioAnterior != null) {
        final precioAnt = (precioAnterior as num).toDouble();
        descuentos += (precioAnt - precio) * cantidad;
      }
    }

    setState(() {
      resumen = {
        'subtotal': subtotal,
        'descuentos': descuentos,
        'total': subtotal, // Ya el precio incluye el descuento
        'cantidadItems': cantidadItems,
        'cantidadProductos': items.length,
      };
    });
  }

  /// Procesar pago - navegar a página de pago con datos del carrito
  void procesarPago() {
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El carrito está vacío'),
          backgroundColor: Color(0xFFF44336),
        ),
      );
      return;
    }

    // Navegar a página de pago pasando los datos del carrito
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagarPage(
          itemsCarrito: items,
          resumenCarrito: resumen,
        ),  // Aquí pasamos los datos del carrito a PagarPage y redirigimos a la página de pago
      ),
    );
  }

  /// Ir a la página principal
  void irAComprar() {
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      body: _buildBody(),
      bottomNavigationBar: const BarraInferior(indiceActual: 1),
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
                onPressed: cargarCarrito,
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

    if (items.isEmpty) {
      return CompraEmptyWidget(onIrAComprar: irAComprar);
    }

    return Column(
      children: [
        // Lista de productos
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return CompraItemWidget(
                itemId: item['id'],
                producto: item['producto'],
                cantidad: item['cantidad'],
                subtotal: (item['subtotal'] as num).toDouble(),
                onEliminar: () => eliminarItem(item['id']),
                onCantidadChanged:
                    (cantidad) => actualizarCantidad(item['id'], cantidad),
              );
            },
          ),
        ),

        // Resumen y botón de pago
        CompraResumenWidget(
          subtotal: (resumen['subtotal'] as num).toDouble(),
          descuentos: (resumen['descuentos'] as num).toDouble(),
          total: (resumen['total'] as num).toDouble(),
          cantidadItems: resumen['cantidadItems'] as int,
          onPagar: procesarPago,
        ),
      ],
    );
  }
}