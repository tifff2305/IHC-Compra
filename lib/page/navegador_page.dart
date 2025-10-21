import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

class NavegadorPage extends StatelessWidget {
  const NavegadorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'title': 'Tarjeta', 'route': AppRoutes.tarjeta},
      {'title': 'Buscar producto', 'route': AppRoutes.buscar_producto},
      {'title': 'Vista producto', 'route': AppRoutes.vista_producto},
      {'title': 'Compra', 'route': AppRoutes.compra},
      {'title': 'Pagar', 'route': AppRoutes.pagar},
      {'title': 'QR', 'route': AppRoutes.qr},
      {'title': 'Mapa', 'route': AppRoutes.mapa},
      {'title': 'Tracking', 'route': AppRoutes.tracking},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegador'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['title'] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                items[index]['route'] as String,
              );
            },
          );
        },
      ),
    );
  }
}