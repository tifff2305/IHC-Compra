import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

/// Widget para mostrar la ruta de navegación actual (miga de pan)
/// Ejemplo: Principal → Ofertas especiales
class MigaPanWidget extends StatelessWidget {
  final List<String> ruta;

  const MigaPanWidget({super.key, required this.ruta});

  @override
  @override
Widget build(BuildContext context) {
  return Row(
    children: [
      for (int i = 0; i < ruta.length; i++) ...[
        GestureDetector(
          onTap: i == 0
              ? () {
                  // Solo el primer elemento ("Principal") es clickeable
                  Navigator.pushNamed(context, AppRoutes.home);
                }
              : null,
          child: Text(
            ruta[i],
            style: TextStyle(
              color: i == ruta.length - 1
                  ? Colors.black
                  : i == 0
                      ? Colors.black // color tipo link para "Principal"
                      : Colors.grey[700],
              fontWeight: i == ruta.length - 1
                  ? FontWeight.bold
                  : FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        if (i < ruta.length - 1)
          const Icon(Icons.arrow_right, size: 18, color: Colors.grey),
      ],
    ],
  );
}

}
