import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/page/tarjeta/widgets/visa_card_widget.dart';

class TarjetaWidget extends StatefulWidget {
  const TarjetaWidget({super.key});

  @override
  State<TarjetaWidget> createState() => _TarjetaWidgetState();
}

class _TarjetaWidgetState extends State<TarjetaWidget> {
  final TextEditingController _ubicacionCtrl = TextEditingController();

  @override
  void dispose() {
    _ubicacionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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

          
          ],
        ),
      );
  }

}
