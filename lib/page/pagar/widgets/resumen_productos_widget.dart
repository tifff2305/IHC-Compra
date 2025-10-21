import 'package:flutter/material.dart';

class ResumenProductosWidget extends StatelessWidget {
  final List<Map<String, dynamic>> productos;
  final double descuentos;
  final double costoEnvio;
  final double total;

  const ResumenProductosWidget({
    super.key,
    required this.productos,
    required this.descuentos,
    required this.costoEnvio,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen >',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                // Título "Productos"
                const Row(
                  children: [
                    Text(
                      'Productos',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Lista de productos
                ...productos.map((producto) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          producto['nombre'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          'BS ${producto['precio'].toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                // Descuentos
                if (descuentos > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Descuentos',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      Text(
                        '-BS ${descuentos.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
                
                // Costo de envío
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Costo envío',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      costoEnvio > 0
                          ? 'BS ${costoEnvio.toStringAsFixed(0)}'
                          : 'Gratis',
                      style: TextStyle(
                        fontSize: 13,
                        color: costoEnvio > 0 ? Colors.grey[700] : const Color(0xFF4CAF50),
                        fontWeight: costoEnvio > 0 ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                // Divider antes del total
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                  ),
                ),
                
                // TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'BS ${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
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