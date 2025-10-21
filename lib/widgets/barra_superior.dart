import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const BarraSuperior({
    super.key,
    this.titulo = 'Globy',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.navegador);
        },
        child: Text(
          titulo,
          style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.white,
          ),
        ),
      ),
      toolbarHeight: 100,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}