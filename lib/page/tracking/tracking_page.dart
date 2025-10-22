import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/tracking/widgets/estado_widget.dart';
import 'package:ihc_inscripciones/page/tracking/widgets/flecha_widget.dart';
import 'package:ihc_inscripciones/widgets/barra_inferior.dart';
import 'package:ihc_inscripciones/widgets/barra_superior.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? direccion = ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      appBar: const BarraSuperior(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Estado del pedido >', style: TextStyle(fontSize: 10.0)),
            const SizedBox(height: 10.0),

            //Imágen del estado
            Card(
              elevation: 4.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Image.asset(
                    'assets/images/tienda.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            Row(
              children: [
                EstadoWidget(estadoActual: true, nombre: 'local', paso: '1'),
                FlechaWidget(),
                EstadoWidget(estadoActual: false, nombre: "En camino", paso: '2'),
                FlechaWidget(),
                EstadoWidget(estadoActual: false, nombre: "Entregado", paso: '3'),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Información del envio >', style: TextStyle(fontSize: 10.0)),
            const SizedBox(height: 5.0),
            Center(
              child: Card(
                elevation: 4.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Dirección', style: TextStyle(fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            direccion ?? '',
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ]),
                      SizedBox(height: 8.0),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Repartidor', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Juan Pérez'),
                      ]),
                      SizedBox(height: 8.0),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Transporte', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('6581SA'),
                      ]),
                    ],
                  ),
                ),
              ),
            ),


            const SizedBox(height: 16.0),
            const Text('Resumen del pago >', style: TextStyle(fontSize: 10.0)),
            const SizedBox(height: 5.0),
            Center(
              child: const Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Bs 100'),
                      ]),
                      SizedBox(height: 8.0),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Envio', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Bs 15'),
                      ]),
                      Divider(),
                      SizedBox(height: 8.0),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Bs 115'),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferior(indiceActual: 1),
    );
  }
}
