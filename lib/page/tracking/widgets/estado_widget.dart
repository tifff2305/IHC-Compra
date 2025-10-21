import 'package:flutter/material.dart';

class EstadoWidget extends StatelessWidget {
  final bool estadoActual;
  final String nombre;
  final String paso;

  const EstadoWidget({
    super.key,
    required this.estadoActual,
    required this.nombre,
    required this.paso,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = estadoActual ? Color(0xFFE9C152) : Color(0xFFF5E4A1); // más clarito si false
    final textColor = estadoActual ? Colors.black : Colors.white;

    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: backgroundColor,
            child: Text(
              paso,
              style: TextStyle(color: textColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nombre,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
