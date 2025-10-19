import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../widgets/horizontal_carousel.dart';
import '../../widgets/search_bar.dart' as custome;

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> banners = [
      'assets/images/harina.jpg',
      'assets/images/jugo.jpg',
      'assets/images/limpia_piso.jpg',
    ];

    final List<Map<String, dynamic>> topSellers = [
      {
        'name': 'Harina',
        'image': 'assets/images/harina.jpg',
        'price': 20.0,
      },
      {
        'name': 'Jugo Soprole',
        'image': 'assets/images/jugo.jpg',
        'price': 30.0,
      },
      {
        'name': 'Limpia Piso',
        'image': 'assets/images/limpia_piso.jpg',
        'price': 45.0,
      },
    ];

    final List<Map<String, dynamic>> suggestions = [
      {
        'name': 'Harina',
        'image': 'assets/images/harina.jpg',
        'price': 20.0,
      },
      {
        'name': 'Jugo Soprole',
        'image': 'assets/images/jugo.jpg',
        'price': 30.0,
      },
      {
        'name': 'Limpia Piso',
        'image': 'assets/images/limpia_piso.jpg',
        'price': 45.0,
      },
    ];

    // Controlador para el buscador
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Globy',
          style: TextStyle(
            fontSize: 35,
            fontWeight:
                FontWeight.bold, // opcional, para que se vea más destacado
            color: Colors.white,
          ),
        ),
        toolbarHeight: 100,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // BARRA DE BÚSQUEDA
            custome.SearchBar(
              controller: searchController,
              onChanged: (value) {
                // logica de busqueda
              },
              onClear: () {
                searchController.clear();
              },
            ),

            const SizedBox(height: 12),

            // CARRUSEL DE BANNERS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 150.0,
                  autoPlay: true,
                  enlargeCenterPage: false, // Evita el exceso de espacio
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 0.9, // para que no se recorte
                ),
                items:
                    banners.map((img) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          img,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Carrusel de productos: Lo más vendidos
            HorizontalCarousel(title: 'Lo más vendido >', products: topSellers),

            // Carrusel de productos: Sugerencias
            HorizontalCarousel(title: 'Sugerencias >', products: suggestions),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Principal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
