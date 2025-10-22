import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';
import 'package:ihc_inscripciones/page/compra/compra_page.dart';

class TarjetaProducto extends StatelessWidget {
  final String id;
  final String nombre;
  final String imagen;
  final double precio;
  final VoidCallback onAgregar;

  const TarjetaProducto({
    super.key,
    required this.id,
    required this.nombre,
    required this.imagen,
    required this.precio,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ⭐ Al tocar la tarjeta completa → ir a detalle del producto
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.vista_producto,
          arguments: {'productoId': id},
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Imagen del producto
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // ⭐ Fondo blanco
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imagen,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                ),
              ),
            ),

            // Sombra superior para mejorar legibilidad
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),

            // Info + botón flotante
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nombre y precio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Bs ${precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ⭐ Ícono "shopping_cart" (Agregar al carrito)
                  GestureDetector(
                    // ⭐ Evitar que el tap del ícono active el tap de la tarjeta
                    onTap: () async {
                      // Cargar el producto completo desde JSON
                      final jsonString = await DefaultAssetBundle.of(
                        context,
                      ).loadString('assets/data/productos.json');
                      final data = json.decode(jsonString);

                      final producto = (data['productos'] as List)
                          .cast<Map<String, dynamic>>()
                          .firstWhere((p) => p['id'] == id);

                      // ⭐ Agregar al carrito (cantidad 1)
                      CarritoGlobal.agregar(producto, 1);

                      // ⭐ Mostrar SnackBar con confirmación
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$nombre x1 agregado al carrito ✅'),
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
                      }
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
