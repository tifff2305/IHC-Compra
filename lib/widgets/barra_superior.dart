import 'package:flutter/material.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const BarraSuperior({
    super.key,
    this.titulo = 'Globy',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titulo,
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      toolbarHeight: 100,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}