import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

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
    return Container(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagen,
                fit: BoxFit.cover,
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
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                ],
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
                        '\Bs${precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Ícono “+” (Agregar al carrito)
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: (){
                      Navigator.pushNamed(context, AppRoutes.vista_producto, arguments: {'productoId': id});
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                    tooltip: 'Agregar al carrito',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
