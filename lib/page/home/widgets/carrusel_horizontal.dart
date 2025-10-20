import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/home/widgets/tarjeta_producto.dart';

class CarruselHorizontal extends StatelessWidget {
  final String titulo;
  final List<Map<String, dynamic>> productos;

  const CarruselHorizontal({
    super.key,
    required this.titulo,
    required this.productos,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 108, 107, 107),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productos.length,
            padding: const EdgeInsets.only(left: 8),
            itemBuilder: (context, index) {
              final producto = productos[index];
              return TarjetaProducto(
                nombre: producto['nombre'],
                imagen: producto['imagen'],
                precio: producto['precio'],
                precioAnterior: producto['precioAnterior'],
                enOferta: producto['enOferta'] ?? false,
                alAgregar: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${producto['nombre']} agregado al carrito'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}