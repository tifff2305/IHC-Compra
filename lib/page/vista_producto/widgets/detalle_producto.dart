import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/compra/compra_page.dart'; // ⭐ NUEVA
import 'package:ihc_inscripciones/page/pagar/pagar_page.dart'; // ⭐ NUEVA

/// Widget que muestra los detalles del producto, su imagen, precio y cantidad.
class DetalleProductoWidget extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetalleProductoWidget({super.key, required this.producto});

  @override
  DetalleProductoWidgetState createState() => DetalleProductoWidgetState();
}

class DetalleProductoWidgetState extends State<DetalleProductoWidget> {
  int cantidad = 1;

  void _incrementar() => setState(() => cantidad++);
  void _disminuir() {
    if (cantidad > 1) setState(() => cantidad--);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.producto;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen
        Container(
          width: 140,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: p['imagen'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    p['imagen'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported);
                    },
                  ),
                )
              : const Icon(Icons.image_not_supported),
        ),
        const SizedBox(width: 16),

        // Detalles
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p['nombre'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'BS ${p['precio']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cantidad:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Botón disminuir (-)
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _disminuir,
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: 20,
                          ),
                          tooltip: 'Disminuir cantidad',
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Texto de cantidad
                      Text(
                        '$cantidad',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Botón aumentar (+)
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _incrementar,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                          tooltip: 'Aumentar cantidad',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ⭐ BOTÓN "COMPRA YA!" - COMPRA RÁPIDA
              ElevatedButton(
                onPressed: () {
                  // ⭐ Crear item temporal para compra rápida
                  final itemCompraRapida = {
                    'id': 'compra_rapida_${DateTime.now().millisecondsSinceEpoch}',
                    'producto': p,
                    'cantidad': cantidad,
                    'subtotal': (p['precio'] as num).toDouble() * cantidad,
                    'fechaAgregado': DateTime.now().toIso8601String(),
                  };

                  // ⭐ Calcular resumen
                  final precio = (p['precio'] as num).toDouble();
                  final precioAnterior = p['precioAnterior'];
                  final subtotal = precio * cantidad;
                  
                  double descuento = 0.0;
                  if (precioAnterior != null) {
                    final precioAnt = (precioAnterior as num).toDouble();
                    descuento = (precioAnt - precio) * cantidad;
                  }

                  final resumenCompraRapida = {
                    'subtotal': subtotal,
                    'descuentos': descuento,
                    'total': subtotal,
                    'cantidadItems': cantidad,
                    'cantidadProductos': 1,
                  };

                  // ⭐ Navegar directamente a PagarPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagarPage(
                        itemsCarrito: [itemCompraRapida],
                        resumenCarrito: resumenCompraRapida,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Compra Ya!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}