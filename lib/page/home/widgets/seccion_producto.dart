import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';
import 'tarjeta_producto.dart';

/// Widget que muestra una sección con un título
/// y un carrusel horizontal de tarjetas de productos.
class SeccionProducto extends StatelessWidget {
  /// Título visible en la parte superior de la sección
  final String titulo;

  /// Nombre de la colección en el JSON (por ejemplo: "mas_vendidos")
  final String coleccion;

  /// Datos completos cargados desde el JSON, enviados desde HomePage
  final Map<String, dynamic> datos;

  const SeccionProducto({
    super.key,
    required this.titulo,
    required this.coleccion,
    required this.datos,
  });

  @override
  Widget build(BuildContext context) {
    /// Obtenemos los IDs de productos que pertenecen a esta colección
    final List<String> ids = List<String>.from(
      (datos['colecciones']?[coleccion] ?? []),
    );

    /// Filtramos los productos que coinciden con esos IDs
    final List productos =
        (datos['productos'] ?? []).where((p) => ids.contains(p['id'])).toList();

    /// Si no hay productos, no mostramos nada
    if (productos.isEmpty) {
      return const SizedBox.shrink();
    }

    /// Sección con título y carrusel horizontal
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Título clickeable que navega a la vista BuscarProducto
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.buscar_producto,
                arguments: {'coleccion': coleccion},
              );
            },
            child: Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // color para indicar que es clickeable
              ),
            ),
          ),

          const SizedBox(height: 10),

          /// Carrusel horizontal con los productos
          CarouselSlider(
            options: CarouselOptions(
              height: 180,
              enableInfiniteScroll: false,
              viewportFraction: 0.45,
              enlargeCenterPage: false,
              padEnds: false, // opcional para evitar borde inicial
            ),
            items: productos.map((producto) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TarjetaProducto(
                      id: producto['id'],
                      nombre: producto['nombre'],
                      imagen: producto['imagen'],
                      precio: producto['precio'],
                      onAgregar: () {
                        // carrito.agregar(producto);
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
