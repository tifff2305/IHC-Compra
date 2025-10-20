import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/core/app_theme.dart';

class TarjetaProducto extends StatelessWidget {
  final String nombre;
  final String imagen;
  final double precio;
  final double? precioAnterior;
  final VoidCallback alAgregar;
  final bool enOferta;

  const TarjetaProducto({
    super.key,
    required this.nombre,
    required this.imagen,
    required this.precio,
    this.precioAnterior,
    required this.alAgregar,
    this.enOferta = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con botón flotante "+" y etiqueta de oferta
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  imagen,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ),
              // Etiqueta de oferta
              if (enOferta)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'OFERTA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Botón agregar
              Positioned(
                right: 8,
                bottom: 8,
                child: GestureDetector(
                  onTap: alAgregar,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          // Texto del producto
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Precios
                Row(
                  children: [
                    Text(
                      'Bs ${precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    if (precioAnterior != null) ...[
                      const SizedBox(width: 4),
                      Text(
                        'Bs ${precioAnterior!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}