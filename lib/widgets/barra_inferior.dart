import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../page/compra/compra_page.dart';

class BarraInferior extends StatefulWidget {
  final int indiceActual;

  const BarraInferior({super.key, required this.indiceActual});

  @override
  State<BarraInferior> createState() => _BarraInferiorState();
}

class _BarraInferiorState extends State<BarraInferior> {
  @override
  void initState() {
    super.initState();
    // ⭐ Escuchar cambios del carrito
    CarritoGlobal().addListener(_actualizarBadge);
  }

  @override
  void dispose() {
    // ⭐ Remover listener
    CarritoGlobal().removeListener(_actualizarBadge);
    super.dispose();
  }

  // ⭐ Actualizar badge cuando cambia el carrito
  void _actualizarBadge() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ Obtener cantidad de items en el carrito
    final cantidadCarrito = CarritoGlobal.getCantidadTotal();

    return BottomNavigationBar(
      currentIndex: widget.indiceActual,
      selectedItemColor: const Color(0xFF2196F3),
      unselectedItemColor: Colors.grey,
      onTap: (indice) {
        switch (indice) {
          case 0:
            if (widget.indiceActual != 0) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            }
            break;
          case 1:
            if (widget.indiceActual != 1) {
              Navigator.pushReplacementNamed(context, AppRoutes.compra);
            }
            break;
          case 2:
            if (widget.indiceActual != 2) {
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
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Principal',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_cart),
              if (cantidadCarrito > 0)
                Positioned(
                  right: -8,
                  top: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cantidadCarrito > 99 ? '99+' : '$cantidadCarrito',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          label: 'Compras',
        ),
        
      ],
    );
  }
}