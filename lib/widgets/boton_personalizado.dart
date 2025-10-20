import 'package:flutter/material.dart';

class BotonPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback alPresionar;
  final bool estaCargando;
  final Color? colorFondo;
  final Color? colorTexto;
  final double? ancho;
  final double alto;
  final IconData? icono;

  const BotonPersonalizado({
    super.key,
    required this.texto,
    required this.alPresionar,
    this.estaCargando = false,
    this.colorFondo,
    this.colorTexto,
    this.ancho,
    this.alto = 50,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho,
      height: alto,
      child: ElevatedButton(
        onPressed: estaCargando ? null : alPresionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorFondo ?? const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child:
            estaCargando
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icono != null) ...[
                      Icon(icono, color: colorTexto ?? Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      texto,
                      style: TextStyle(
                        color: colorTexto ?? Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
