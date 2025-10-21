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

  /// Carga el JSON de productos desde assets
  Future<void> _cargarDatos() async {
    try {
      final data = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/data/productos.json');
      setState(() {
        datosProductos = json.decode(data);
      });
    } catch (e) {
      print('Error cargando productos.json: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recuperar argumentos (colección) desde la navegación
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    coleccion = args?['coleccion'];

    return Scaffold(
      appBar: const BarraSuperior(),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
      body:
          datosProductos == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  const SizedBox(height: 10),

                  /// Barra de búsqueda fija (no se desplaza)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: BarraBusqueda(
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
                  ),

                  const SizedBox(height: 10),

                  /// Contenido desplazable (miga de pan + productos)
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Miga de pan
                          MigaPanWidget(ruta: ['Principal', coleccion ?? '']),

                          const SizedBox(height: 20),

                          /// Productos filtrados por colección y texto
                          Productos(
                            coleccion: coleccion,
                            datos: datosProductos!,
                            filtro: textoBusqueda,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
