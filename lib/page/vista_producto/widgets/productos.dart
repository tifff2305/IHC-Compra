import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';
import 'tarjeta_producto.dart';

/// Muestra los productos de una colección específica en formato Grid.
class Productos extends StatelessWidget {
  final Map<String, dynamic> datos;
  final List<Map<String, dynamic>>? productosFiltrados;
  final String? coleccion;
  final String filtro;

  const Productos({
    super.key,
    required this.datos,
    this.productosFiltrados,
    this.coleccion,
    this.filtro = '',
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> productos = productosFiltrados ??
        List<Map<String, dynamic>>.from(datos['productos'] ?? []);

    // Filtrado por colección
    if (coleccion != null && coleccion!.isNotEmpty) {
      final ids = List<String>.from((datos['colecciones']?[coleccion] ?? []));
      productos = productos.where((p) => ids.contains(p['id'])).toList();
    }

    // Filtrado por texto
    if (filtro.isNotEmpty) {
      productos = productos
          .where(
            (p) => (p['nombre'] ?? '')
                .toString()
                .toLowerCase()
                .contains(filtro),
          )
          .toList();
    }

    if (productos.isEmpty) {
      return const Center(child: Text('No se encontraron productos.'));
    }

    return GridView.builder(
      itemCount: productos.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final p = productos[index];
        return TarjetaProducto(
          id: p['id'],
          nombre: p['nombre'],
          imagen: p['imagen'] ?? 'assets/images/default.png',
          precio: (p['precio'] as num).toDouble(),
          onAgregar: () {
            Navigator.pushNamed(
              context,
              AppRoutes.vista_producto,
              arguments: {'productoId': p['id']},
            );
          },
        );
      },
    );
  }
}

