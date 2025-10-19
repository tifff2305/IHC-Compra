import 'package:flutter/material.dart';
import 'product_card.dart';

class HorizontalCarousel extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> products;

  const HorizontalCarousel({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 108, 107, 107),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                name: product['name'],
                image: product['image'],
                price: product['price'],
                onAdd: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${product['name']} agregado al carrito")),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
