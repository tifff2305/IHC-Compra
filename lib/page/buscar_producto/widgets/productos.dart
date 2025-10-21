import 'package:flutter/material.dart';
import 'tarjeta_producto.dart';

/// Muestra los productos de una colección específica en formato Grid.
class Productos extends StatelessWidget {
  final Map<String, dynamic> datos;
  final String? coleccion;
  final String filtro;

  const Productos({
    super.key,
    required this.coleccion,
    required this.datos,
    this.filtro = '',
  });

  @override
  Widget build(BuildContext context) {
    // Obtiene los productos desde el JSON
    final productos = List<Map<String, dynamic>>.from(datos['productos'] ?? []);

    // Filtra por colección si corresponde
    List<Map<String, dynamic>> productosFiltrados = productos;
    if (coleccion != null && coleccion!.isNotEmpty) {
      final ids = List<String>.from((datos['colecciones']?[coleccion] ?? []));
      productosFiltrados =
          productos.where((p) => ids.contains(p['id'])).toList();
    }

    // Filtra por texto de búsqueda
    if (filtro.isNotEmpty) {
      productosFiltrados =
          productosFiltrados
              .where(
                (p) => (p['nombre'] ?? '').toString().toLowerCase().contains(
                  filtro,
                ),
              )
              .toList();
    }

    if (productosFiltrados.isEmpty) {
      return const Center(child: Text('No se encontraron productos.'));
    }
    return GridView.builder(
      itemCount: productosFiltrados.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final p = productosFiltrados[index];
        return TarjetaProducto(
          id: p['id'],
          nombre: p['nombre'],
          imagen: p['imagen'],
          precio: p['precio'],
          onAgregar: () {},
        );
      },
    );
  }
}
