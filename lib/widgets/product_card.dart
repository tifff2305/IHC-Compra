import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String image;
  final double price;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Imagen con botón flotante "+" ---
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          // --- Texto del producto ---
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "\Bs ${price.toStringAsFixed(2)}",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
