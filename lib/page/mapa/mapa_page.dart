import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'utils/mapa_utils.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final MapController _mapController = MapController();
  LatLng? _seleccionado;
  String? _direccion;

  //UAGRM - FICCT
  final LatLng ubiDefecto = const LatLng(
    -17.776204429593825,
    -63.19505988462873,
  );

  void _confirmarUbicacion() {
    if (_seleccionado != null) {
      Navigator.of(context).pop<String>(_direccion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final LatLng initialCenter =
        (args is LatLng) ? args : (_seleccionado ?? ubiDefecto);

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona ubicación')),
      body: Stack(
        children: [
          //Mapa
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 13,
              onTap: (tapPosition, point) async {
                setState(() {
                  _seleccionado = point;
                  _direccion = 'Obteniendo dirección...';
                });
                final direccion = await obtenerDireccion(point);
                setState(() {
                  _direccion = direccion;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'ihc',
              ),
              if (_seleccionado != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _seleccionado!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          //Boton Usar ubicacion
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: ElevatedButton.icon(
              onPressed: _seleccionado == null ? null : _confirmarUbicacion,
              icon: const Icon(Icons.check),
              label: Text(
                _seleccionado == null
                    ? 'Toca el mapa para elegir'
                    : _direccion ?? 'Ubicación seleccionada',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}
