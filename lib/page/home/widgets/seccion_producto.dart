import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';
import 'tarjeta_producto.dart';

/// SeccionProducto ahora soporta:
/// - coleccion: listar por colecciones definidas en datos['colecciones']
/// - categoria: listar por el campo producto['categoria']
/// Si se pasa categoria, tiene prioridad sobre coleccion.
class SeccionProducto extends StatelessWidget {
  final String titulo;
  final String? coleccion; // ahora opcional
  final String? categoria; // nuevo: opcional
  final Map<String, dynamic> datos;

  const SeccionProducto({
    super.key,
    required this.titulo,
    required this.datos,
    this.coleccion,
    this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    // Lista base de productos (como Map)
    final List<Map<String, dynamic>> allProducts =
        List<Map<String, dynamic>>.from(datos['productos'] ?? []);

    // Si se pidió filtrar por categoría -> usamos esa lista
    List<Map<String, dynamic>> productos = [];
    if (categoria != null && categoria!.isNotEmpty) {
      productos =
          allProducts
              .where((p) => (p['categoria'] ?? '') == categoria)
              .toList();
    } else if (coleccion != null && coleccion!.isNotEmpty) {
      // Si no hay categoria, pero sí coleccion -> usar colecciones del JSON
      final List<String> ids = List<String>.from(
        (datos['colecciones']?[coleccion] ?? []),
      );
      productos = allProducts.where((p) => ids.contains(p['id'])).toList();
    }

    if (productos.isEmpty) {
      return const SizedBox.shrink();
    }

    /// Sección con título y carrusel horizontal
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título clickeable (si quieres que abra la búsqueda por coleccion)
          GestureDetector(
            onTap: () {
              // si existe coleccion navega a BuscarProducto, si no, navega pasando la categoria
              if (coleccion != null && coleccion!.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.buscar_producto,
                  arguments: {'coleccion': coleccion},
                );
              } else if (categoria != null && categoria!.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.buscar_producto,
                  arguments: {'categoria': categoria},
                );
              }
            },
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 10),

          CarouselSlider(
            options: CarouselOptions(
              height: 180,
              enableInfiniteScroll: false,
              viewportFraction: 0.45,
              enlargeCenterPage: false,
              padEnds: false,
            ),
            items:
                productos.map((producto) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TarjetaProducto(
                      id: producto['id'],
                      nombre: producto['nombre'],
                      imagen: producto['imagen'],
                      precio:
                          (producto['precio'] as num)
                              .toDouble(),
                      onAgregar: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.vista_producto,
                          arguments: {'productoId': producto['id']},
                        );
                      },
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
