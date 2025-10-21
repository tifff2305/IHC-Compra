import 'package:flutter/material.dart';

/// Widget que muestra los detalles del producto, su imagen, precio y cantidad.
class DetalleProductoWidget extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetalleProductoWidget({super.key, required this.producto});

  @override
  State<DetalleProductoWidget> createState() => _DetalleProductoWidgetState();
}

class _DetalleProductoWidgetState extends State<DetalleProductoWidget> {
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
          width: 140, //ancho
          height: 200,
          color: Colors.grey[300],
          child:
              p['imagen'] != null
                  ? Image.asset(p['imagen'], fit: BoxFit.cover)
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

              ElevatedButton(
                onPressed: () {
                  // Lógica de agregar al carrito
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${p['nombre']} x$cantidad agregado al carrito',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C3E50), // fondo azul marino
                  foregroundColor: Colors.white, // texto blanco
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // bordes redondeados
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
