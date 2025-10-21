import 'package:flutter/material.dart';

class MetodoPagoWidget extends StatelessWidget {
  final List<Map<String, dynamic>> metodos;
  final String? metodoSeleccionado;
  final Function(String) onMetodoSeleccionado;

  const MetodoPagoWidget({
    super.key,
    required this.metodos,
    required this.metodoSeleccionado,
    required this.onMetodoSeleccionado,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'qr_code':
        return Icons.qr_code;
      case 'credit_card':
        return Icons.credit_card;
      case 'payments':
        return Icons.payments;
      default:
        return Icons.payment;
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
            'Método de pago >',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: metodos.map((metodo) {
              final isSelected = metodoSeleccionado == metodo['id'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onMetodoSeleccionado(metodo['id']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2196F3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2196F3)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.05 * 255).round()),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconData(metodo['icono']),
                          size: 32,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          metodo['nombre'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}