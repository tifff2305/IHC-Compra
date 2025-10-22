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

// ⭐ CARRITO GLOBAL CON NOTIFICACIONES
class CarritoGlobal extends ChangeNotifier {
  static final CarritoGlobal _instance = CarritoGlobal._internal();
  factory CarritoGlobal() => _instance;
  CarritoGlobal._internal();

  static List<dynamic> _items = [];

  // Agregar producto al carrito
  static void agregar(Map<String, dynamic> producto, int cantidad) {
    final index = _items.indexWhere(
      (item) => item['producto']['id'] == producto['id'],
    );

    if (index != -1) {
      _items[index]['cantidad'] += cantidad;
      _items[index]['subtotal'] =
          (_items[index]['producto']['precio'] as num).toDouble() *
              _items[index]['cantidad'];
    } else {
      final nuevoItem = {
        'id': 'compra_${DateTime.now().millisecondsSinceEpoch}',
        'producto': producto,
        'cantidad': cantidad,
        'subtotal': (producto['precio'] as num).toDouble() * cantidad,
        'fechaAgregado': DateTime.now().toIso8601String(),
      };
      _items.add(nuevoItem);
    }
    
    // ⭐ Notificar cambios
    _instance.notifyListeners();
  }

  // Obtener items
  static List<dynamic> getItems() {
    return List.from(_items);
  }

  // Actualizar item en carrito global
  static void actualizarItem(String itemId, int nuevaCantidad) {
    final index = _items.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      final precioUnitario =
          (_items[index]['producto']['precio'] as num).toDouble();
      _items[index]['cantidad'] = nuevaCantidad;
      _items[index]['subtotal'] = precioUnitario * nuevaCantidad;
    }
    
    // ⭐ Notificar cambios
    _instance.notifyListeners();
  }

  // Eliminar item
  static void eliminar(String itemId) {
    _items.removeWhere((item) => item['id'] == itemId);
    
    // ⭐ Notificar cambios
    _instance.notifyListeners();
  }

  // Limpiar carrito
  static void limpiar() {
    _items.clear();
    
    // ⭐ Notificar cambios
    _instance.notifyListeners();
  }

  // Obtener cantidad total
  static int getCantidadTotal() {
    return _items.fold(0, (sum, item) => sum + (item['cantidad'] as int));
  }
}

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
    
    // ⭐ Escuchar cambios del carrito
    CarritoGlobal().addListener(_actualizarCarrito);
  }

  @override
  void dispose() {
    // ⭐ Remover listener
    CarritoGlobal().removeListener(_actualizarCarrito);
    super.dispose();
  }

  // ⭐ Actualizar cuando cambia el carrito
  void _actualizarCarrito() {
    cargarCarrito();
  }

  /// Cargar carrito desde memoria
  Future<void> cargarCarrito() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      setState(() {
        items = CarritoGlobal.getItems();
        calcularTotales();
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
      final indexLocal = items.indexWhere((item) => item['id'] == itemId);
      if (indexLocal != -1) {
        final precioUnitario =
            (items[indexLocal]['producto']['precio'] as num).toDouble();
        items[indexLocal]['cantidad'] = nuevaCantidad;
        items[indexLocal]['subtotal'] = precioUnitario * nuevaCantidad;
      }

      CarritoGlobal.actualizarItem(itemId, nuevaCantidad);
      calcularTotales();
    });
  }

  /// Eliminar un item del carrito
  void eliminarItem(String itemId) {
    setState(() {
      items.removeWhere((item) => item['id'] == itemId);
      CarritoGlobal.eliminar(itemId);
      calcularTotales();
    });

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

      if (precioAnterior != null) {
        final precioAnt = (precioAnterior as num).toDouble();
        descuentos += (precioAnt - precio) * cantidad;
      }
    }

    setState(() {
      resumen = {
        'subtotal': subtotal,
        'descuentos': descuentos,
        'total': subtotal,
        'cantidadItems': cantidadItems,
        'cantidadProductos': items.length,
      };
    });
  }

  /// Procesar pago
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PagarPage(
          itemsCarrito: items,
          resumenCarrito: resumen,
        ),
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