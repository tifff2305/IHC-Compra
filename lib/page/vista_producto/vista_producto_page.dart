import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/vista_producto/widgets/detalle_producto.dart';
import 'package:ihc_inscripciones/page/vista_producto/widgets/miga_pan.dart';
import 'package:ihc_inscripciones/page/vista_producto/widgets/productos.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/widgets/boton_personalizado.dart';
import 'package:ihc_inscripciones/page/compra/compra_page.dart'; // ⭐ Importar CarritoGlobal
import 'package:ihc_inscripciones/routes/app_routes.dart';

/// Página principal que muestra la vista de un producto seleccionado.
class VistaProductoPage extends StatefulWidget {
  const VistaProductoPage({super.key});

  @override
  State<VistaProductoPage> createState() => _VistaProductoPageState();
}

class _VistaProductoPageState extends State<VistaProductoPage> {
  Map<String, dynamic>? datosProductos;
  Map<String, dynamic>? productoSeleccionado;

  // Key para acceder al estado del DetalleProducto
  final GlobalKey<DetalleProductoWidgetState> _detalleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/data/productos.json');
      setState(() {
        datosProductos = json.decode(data);
      });
    } catch (e) {
      print('Error cargando productos.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final productoId = args?['productoId'];

    if (datosProductos == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    productoSeleccionado = (datosProductos!['productos'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((p) => p['id'] == productoId, orElse: () => {});

    if (productoSeleccionado == null || productoSeleccionado!.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Producto no encontrado')),
      );
    }

    // productos similares
    final colecciones = datosProductos!['colecciones'] ?? {};
    final similares = <Map<String, dynamic>>[];
    colecciones.forEach((coleccion, ids) {
      if ((ids as List).contains(productoId)) {
        similares.addAll(
          (ids as List)
              .map(
                (id) => (datosProductos!['productos'] as List)
                    .cast<Map<String, dynamic>>()
                    .firstWhere((p) => p['id'] == id),
              )
              .where((p) => p['id'] != productoId),
        );
      }
    });

    return Scaffold(
      appBar: const BarraSuperior(),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 👇 Botón global personalizado, fijo sobre la barra inferior
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: BotonPersonalizado(
              texto: 'Agregar al carrito',
              icono: Icons.shopping_cart_outlined,
              colorFondo: const Color(0xFF2C3E50),
              colorTexto: Colors.white,
              alPresionar: () {
                // ⭐ Obtener la cantidad del widget DetalleProducto
                final cantidad = _detalleKey.currentState?.cantidad ?? 1;

                // ⭐ Agregar al carrito usando CarritoGlobal
                CarritoGlobal.agregar(productoSeleccionado!, cantidad);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${productoSeleccionado!['nombre']} x$cantidad agregado al carrito ✅',
                    ),
                    backgroundColor: const Color(0xFF4CAF50),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'Ver carrito',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.compra);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const BarraInferior(indiceActual: 0),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MigaPanWidget(ruta: ['Principal', productoSeleccionado!['nombre']]),
            const SizedBox(height: 20),

            /// Widget con key para acceder a la cantidad
            DetalleProductoWidget(
              key: _detalleKey,
              producto: productoSeleccionado!,
            ),

            const SizedBox(height: 24),
            const Text(
              'Productos similares >',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// Widget que muestra los productos sugeridos
            Productos(datos: datosProductos!, productosFiltrados: similares),
          ],
        ),
      ),
    );
  }
}