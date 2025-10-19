import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const SearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
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
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 14, // tamaño de la letra
                ),
                decoration: const InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: TextStyle(
                    fontSize: 14, // tamaño del hint
                    color: Color.fromARGB(255, 130, 128, 128), // color del hint
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            if (controller.text.isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close, color: Color.fromARGB(255, 255, 255, 255)),
              ),
          ],
        ),
      ),
    );
  }
}
