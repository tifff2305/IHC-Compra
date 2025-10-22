import 'package:flutter/material.dart';

class CompraItemWidget extends StatelessWidget {
  final String itemId;
  final Map<String, dynamic> producto;
  final int cantidad;
  final double subtotal;
  final VoidCallback onEliminar;
  final Function(int) onCantidadChanged;

  const CompraItemWidget({
    super.key,
    required this.itemId,
    required this.producto,
    required this.cantidad,
    required this.subtotal,
    required this.onEliminar,
    required this.onCantidadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder de imagen
          // Imagen del producto
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                producto['imagen'] ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.image, color: Colors.grey[400], size: 32),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Información del producto (izquierda)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto['nombre'] ?? 'Sin nombre',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                // Etiqueta "Cantidad"
                const Text(
                  "Cantidad",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                // Botón eliminar
                TextButton(
                  onPressed: onEliminar,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // ← CAMBIO: quitar padding
                    alignment:
                        Alignment
                            .centerLeft, // ← CAMBIO: alinear a la izquierda
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(color: Color(0xFFF44336), fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Columna derecha: Precio, Cantidad y Eliminar
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Precio
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Bs. ${subtotal.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const SizedBox(height: 2),

              // Controles de cantidad
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón disminuir
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.remove,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed:
                          cantidad > 1
                              ? () => onCantidadChanged(cantidad - 1)
                              : null,
                    ),
                  ),

                  // Cantidad actual
                  Container(
                    width: 35,
                    alignment: Alignment.center,
                    child: Text(
                      "$cantidad",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Botón aumentar
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: () => onCantidadChanged(cantidad + 1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }
}
