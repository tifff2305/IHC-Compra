import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/buscar_producto/widgets/barra_busqueda.dart';
import 'package:ihc_inscripciones/page/buscar_producto/widgets/miga_pan.dart';
import 'package:ihc_inscripciones/page/buscar_producto/widgets/productos.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';

/// Página que muestra los productos filtrados por categoría o colección.
/// Se activa al presionar el título de una sección en la pantalla principal.
class BuscarProductoPage extends StatefulWidget {
  const BuscarProductoPage({super.key});

  @override
  State<BuscarProductoPage> createState() => _BuscarProductoPageState();
}

class _BuscarProductoPageState extends State<BuscarProductoPage> {
  final TextEditingController controladorBusqueda = TextEditingController();
  Map<String, dynamic>? datosProductos;
  String textoBusqueda = '';
  String? coleccion;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /// Carga el JSON de productos
  Future<void> _cargarDatos() async {
    try {
      // lee directamente del lib (no de assets)
      final data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/data/productos.json');
      final jsonMap = json.decode(data);
      setState(() {
        datosProductos = jsonMap;
      });
    } catch (e) {
      print('Error cargando productos.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recuperar argumentos de la navegación
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final coleccion = args?['coleccion'];

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

                    /// Barra de búsqueda ocupa todo el ancho
                    BarraBusqueda(
                      controlador: controladorBusqueda,
                      alCambiar: (valor) {
                        setState(() {
                          textoBusqueda = valor.toLowerCase();
                        });
                      },
                      alLimpiar: () {
                        controladorBusqueda.clear();
                        setState(() {
                          textoBusqueda = '';
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    /// Contenido con padding horizontal
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Miga de pan
                          MigaPanWidget(ruta: ['Principal', coleccion]),

                          const SizedBox(height: 20),

                          /// Productos (usa scroll interno o se adapta al scroll del padre)
                          Productos(
                            coleccion: coleccion,
                            datos: datosProductos!,
                            filtro: textoBusqueda,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
