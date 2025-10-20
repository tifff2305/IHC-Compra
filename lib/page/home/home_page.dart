import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ihc_inscripciones/page/home/widgets/carrusel_horizontal.dart';
import 'package:ihc_inscripciones/page/home/widgets/barra_busqueda.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controladorBusqueda = TextEditingController();
  
  Map<String, dynamic> datosProductos = {};
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    try {
      final String respuesta = await rootBundle.loadString('lib/data/productos.json');
      final datos = json.decode(respuesta);
      setState(() {
        datosProductos = datos;
        cargando = false;
      });
    } catch (e) {
      print('Error al cargar productos: $e');
      setState(() {
        cargando = false;
      });
    }
  }

  List<Map<String, dynamic>> obtenerProductosPorIds(List<String> ids) {
    if (datosProductos.isEmpty || datosProductos['productos'] == null) {
      return [];
    }
    
    List<Map<String, dynamic>> productos = [];
    for (var id in ids) {
      var producto = (datosProductos['productos'] as List).firstWhere(
        (p) => p['id'] == id,
        orElse: () => null,
      );
      if (producto != null) {
        productos.add({
          'nombre': producto['nombre'],
          'imagen': producto['imagen'],
          'precio': producto['precio'],
          'precioAnterior': producto['precioAnterior'],
          'enOferta': producto['enOferta'] ?? false,
        });
      }
    }
    return productos;
  }

  @override
  void dispose() {
    controladorBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> banners = [
      'assets/images/harina.jpg',
      'assets/images/jugo.jpg',
      'assets/images/limpia_piso.jpg',
    ];

    // Obtener productos de las colecciones
    List<Map<String, dynamic>> masVendidos = [];
    List<Map<String, dynamic>> ofertas = [];
    List<Map<String, dynamic>> sugerencias = [];

    if (!cargando && datosProductos['colecciones'] != null) {
      masVendidos = obtenerProductosPorIds(
        List<String>.from(datosProductos['colecciones']['mas_vendidos'] ?? [])
      );
      ofertas = obtenerProductosPorIds(
        List<String>.from(datosProductos['colecciones']['ofertas'] ?? [])
      );
      sugerencias = obtenerProductosPorIds(
        List<String>.from(datosProductos['colecciones']['sugerencias'] ?? [])
      );
    }

    return Scaffold(
      appBar: const BarraSuperior(),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),

                  // BARRA DE BÚSQUEDA
                  BarraBusqueda(
                    controlador: controladorBusqueda,
                    alCambiar: (valor) {
                      // Lógica de búsqueda
                      print('Buscando: $valor');
                    },
                    alLimpiar: () {
                      controladorBusqueda.clear();
                      setState(() {});
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
                        enlargeCenterPage: false,
                        aspectRatio: 16 / 9,
                        autoPlayInterval: const Duration(seconds: 3),
                        viewportFraction: 0.9,
                      ),
                      items: banners.map((img) {
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

                  // CARRUSELES DE PRODUCTOS
                  if (masVendidos.isNotEmpty)
                    CarruselHorizontal(
                      titulo: 'Lo más vendido >',
                      productos: masVendidos,
                    ),

                  if (ofertas.isNotEmpty)
                    CarruselHorizontal(
                      titulo: 'Ofertas especiales >',
                      productos: ofertas,
                    ),

                  if (sugerencias.isNotEmpty)
                    CarruselHorizontal(
                      titulo: 'Sugerencias >',
                      productos: sugerencias,
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
    );
  }
}