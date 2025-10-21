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
      selectedItemColor: const Color(0xFF2196F3),
      unselectedItemColor: Colors.grey,
      onTap: (indice) {
        switch (indice) {
          case 0:
            // Ir a Principal
            if (indiceActual != 0) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            break;
          case 1:
            // Ir a Compras
            if (indiceActual != 1) {
              Navigator.pushReplacementNamed(context, AppRoutes.compra);
            }
            break;
          case 2:
            // Ir a Perfil (cuando esté implementado)
            if (indiceActual != 2) {
              // TODO: Implementar página de perfil
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil - Próximamente'),
                  duration: Duration(seconds: 1),
                ),
              );
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