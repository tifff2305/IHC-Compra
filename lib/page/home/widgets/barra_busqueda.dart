import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/core/app_theme.dart';

class BarraBusqueda extends StatelessWidget {
  final TextEditingController controlador;
  final ValueChanged<String> alCambiar;
  final VoidCallback? alLimpiar;

  const BarraBusqueda({
    super.key,
    required this.controlador,
    required this.alCambiar,
    this.alLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color.fromARGB(255, 188, 188, 189)),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controlador,
                onChanged: alCambiar,
                style: const TextStyle(
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 130, 128, 128),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (controlador.text.isNotEmpty)
              GestureDetector(
                onTap: alLimpiar,
                child: const Icon(
                  Icons.close,
                  color: Color.fromARGB(255, 130, 128, 128),
                ),
              ),
          ],
        ),
      ),
    );
  }
}