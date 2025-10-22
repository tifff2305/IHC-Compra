import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

Future<String> obtenerDireccion(LatLng punto) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      punto.latitude,
      punto.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark lugar = placemarks[0];
      return [
        lugar.street,
        lugar.locality,
        lugar.administrativeArea,
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    }
  } catch (_) {}
  return 'Ubicación seleccionada';
}
