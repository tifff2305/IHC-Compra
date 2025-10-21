import 'package:flutter/material.dart';

/// Widget para mostrar la ruta de navegación actual (miga de pan)
/// Ejemplo: Principal → Ofertas especiales
class MigaPanWidget extends StatelessWidget {
  final List<String> ruta;

  const MigaPanWidget({super.key, required this.ruta});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < ruta.length; i++) ...[
          Text(
            ruta[i],
            style: TextStyle(
              color: i == ruta.length - 1
                  ? Colors.black
                  : Colors.grey[700],
              fontWeight:
                  i == ruta.length - 1 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (i < ruta.length - 1)
            const Icon(Icons.arrow_right, size: 18, color: Colors.grey),
        ],
      ],
    );
  }
}
