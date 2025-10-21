import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// Carrusel de banners con auto reproducción.
class CarruselBanner extends StatelessWidget {
  const CarruselBanner({super.key});

  @override
  Widget build(BuildContext context) {
    /// Lista de imágenes de los banners
    final List<String> banners = [
      'assets/images/harina.jpg',
      'assets/images/jugo.jpg',
      'assets/images/limpia_piso.jpg',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,
          enlargeCenterPage: false,
          aspectRatio: 16 / 9,
          viewportFraction: 0.9,
          padEnds: true,
          autoPlayInterval: const Duration(seconds: 3),
        ),
        items:
            banners.map((img) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
