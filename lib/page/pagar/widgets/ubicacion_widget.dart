import 'package:flutter/material.dart';
import 'package:ihc_inscripciones/routes/app_routes.dart';

/// Widget interactivo que muestra la ubicación de entrega
/// y permite cambiarla navegando a la página del mapa
class UbicacionWidget extends StatelessWidget {
  final String direccion;
  final String ciudad;
  final VoidCallback? onUbicacionCambiada;

  const UbicacionWidget({
    super.key,
    required this.direccion,
    required this.ciudad,
    this.onUbicacionCambiada,
  });

  /// Navegar a la página del mapa para seleccionar/cambiar ubicación
  Future<void> _abrirMapa(BuildContext context) async {
    final resultado = await Navigator.pushNamed(
      context,
      AppRoutes.mapa, //linia para cambiar la ruta el benjas
      arguments: {
        'direccion': direccion,
        'ciudad': ciudad,
      },
    );

    // Si el mapa retornó una nueva ubicación, notificar al padre
    if (resultado != null && onUbicacionCambiada != null) {
      onUbicacionCambiada!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ubicación >',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          
          // Card interactivo de ubicación
          InkWell(
            onTap: () => _abrirMapa(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          direccion,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ciudad,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.edit, color: Colors.grey[400], size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}