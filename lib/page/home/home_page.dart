import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihc_inscripciones/page/home/widgets/barra_busqueda.dart';
import 'package:ihc_inscripciones/page/home/widgets/carrusel_horizontal.dart';
import 'package:ihc_inscripciones/page/home/widgets/seccion_producto.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart'; // ⭐ NUEVA

/// HomePage principal del usuario.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controladorBusqueda = TextEditingController();

  Map<String, dynamic>? datosProductos;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/productos.json',
      );
      final data = json.decode(jsonString);
      setState(() {
        datosProductos = data;
      });
    } catch (e) {
      debugPrint('Error al cargar productos: $e');
    }
  }

  // ⭐ NUEVA FUNCIÓN: Buscar productos
  void _buscarProductos(String texto) {
    if (texto.trim().isEmpty) return;
    
    // Navegar a la página de búsqueda con el texto
    Navigator.pushNamed(
      context,
      AppRoutes.buscar_producto,
      arguments: {'textoBusqueda': texto.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
      body: datosProductos == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),

                /// Barra de búsqueda fija (no se desplaza)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: BarraBusqueda(
                    controlador: controladorBusqueda,
                    alCambiar: (valor) {
                      // ⭐ Opcional: buscar mientras escribe
                      // _buscarProductos(valor);
                    },
                    alLimpiar: () {
                      controladorBusqueda.clear();
                      setState(() {});
                    },
                    // ⭐ NUEVO: Acción al presionar enter o botón de buscar
                    alBuscar: () {
                      _buscarProductos(controladorBusqueda.text);
                    },
                  ),
                ),

                const SizedBox(height: 16),

                /// Contenido desplazable
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Carrusel de banners
                        const CarruselBanner(),

                        const SizedBox(height: 20),

                        /// Secciones de productos
                        SeccionProducto(
                          titulo: 'Lo más vendido >',
                          coleccion: 'mas_vendidos',
                          datos: datosProductos!,
                        ),
                        SeccionProducto(
                          titulo: 'Ofertas especiales >',
                          coleccion: 'ofertas',
                          datos: datosProductos!,
                        ),
                        SeccionProducto(
                          titulo: 'Sugerencias >',
                          coleccion: 'sugerencias',
                          datos: datosProductos!,
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}