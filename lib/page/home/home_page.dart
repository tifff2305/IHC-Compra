import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ihc_inscripciones/page/home/widgets/barra_busqueda.dart';
import 'package:ihc_inscripciones/page/home/widgets/carrusel_horizontal.dart';
import 'package:ihc_inscripciones/page/home/widgets/seccion_producto.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';

/// HomePage principal del usuario.
/// Contiene:
/// - Barra superior
/// - Barra de búsqueda
/// - Carrusel de banners
/// - Secciones de productos
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controladorBusqueda = TextEditingController();

  /// Cargamos el json
  Map<String, dynamic>? datosProductos;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /// Carga el JSON desde assets/data/productos.json
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
      body:
          datosProductos == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    /// Barra de búsqueda
                    BarraBusqueda(
                      controlador: controladorBusqueda,
                      alCambiar: (valor) {
                        print('Buscando: $valor');
                      },
                      alLimpiar: () {
                        controladorBusqueda.clear();
                        setState(() {});
                      },
                    ),

                    const SizedBox(height: 15),

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
    );
  }
}
