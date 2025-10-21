import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/tarjeta/widgets/visa_card_widget.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';
import 'package:ihc_inscripciones/widgets/boton_personalizado.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';
import 'package:latlong2/latlong.dart';

class TarjetaPage extends StatefulWidget {
  const TarjetaPage({super.key});

  @override
  State<TarjetaPage> createState() => _TarjetaPageState();
}

class _TarjetaPageState extends State<TarjetaPage> {
  final TextEditingController _ubicacionCtrl = TextEditingController();

  @override
  void dispose() {
    _ubicacionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Métodos de pago -> Tarjeta",
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(height: 10),

            const VisaCardWidget(),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
              child: TextField(
                controller: _ubicacionCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ubicación de Entrega',
                  hintText: 'Toca para seleccionar en el mapa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                onTap: () async {
                  _seleccionarUbicacion();
                },
              ),
            ),

            const SizedBox(height: 30),
            BotonPersonalizado(
              texto: "Pagar",
                alPresionar: () {
                Navigator.pushNamed(context, AppRoutes.tracking);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _seleccionarUbicacion() async {
    final result = await Navigator.pushNamed(context, AppRoutes.mapa);
    if (result is LatLng) {
      _ubicacionCtrl.text =
          '${result.latitude.toStringAsFixed(6)}, ${result.longitude.toStringAsFixed(6)}';
    }
  }
}
