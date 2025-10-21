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
/// - Barra de búsqueda (fija)
/// - Carrusel de banners
/// - Secciones de productos (scrollable)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controladorBusqueda = TextEditingController();

  Map<String, dynamic>? datosProductos;
  String categoriaSeleccionada = 'todo';

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

  @override
  Widget build(BuildContext context) {
    if (datosProductos == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categorias = [
      {'id': 'todo', 'nombre': 'Todo'},
      ...List<Map<String, dynamic>>.from(datosProductos!['categorias'])
    ];

    return Scaffold(
      appBar: const BarraSuperior(),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: BarraBusqueda(
              controlador: controladorBusqueda,
              alCambiar: (valor) {
                setState(() {});
              },
              alLimpiar: () {
                controladorBusqueda.clear();
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 12),

          /// Filtro horizontal de categorías
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categorias[index];
                final seleccionada = categoriaSeleccionada == cat['id'];
                return ChoiceChip(
                  label: Text(cat['nombre']),
                  selected: seleccionada,
                  onSelected: (_) {
                    setState(() => categoriaSeleccionada = cat['id']);
                  },
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color: seleccionada ? Colors.white : Colors.black,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          /// Contenido desplazable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CarruselBanner(),
                  const SizedBox(height: 20),

                  /// Solo mostramos secciones si no hay filtro
                  if (categoriaSeleccionada == 'todo') ...[
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
                  ] else
                    ///  Si hay categoría seleccionada
                    SeccionProducto(
                      titulo: 'Productos de ${categorias.firstWhere((c) => c['id'] == categoriaSeleccionada)['nombre']}',
                      categoria: categoriaSeleccionada,
                      datos: datosProductos!,
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
