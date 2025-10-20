import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class BarraInferior extends StatelessWidget {
  final int indiceActual;

  const BarraInferior({
    super.key,
    required this.indiceActual,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      onTap: (indice) {
        switch (indice) {
          case 0:
            if (indiceActual != 0) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            break;
          case 1:
            if (indiceActual != 1) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            break;
          case 2:
            if (indiceActual != 2) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Compras',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}