import 'package:flutter/material.dart';

class FlechaWidget extends StatelessWidget {
  const FlechaWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(Icons.arrow_forward, color: Colors.grey),
          const SizedBox(height: 8),
          const Text('', style: TextStyle(fontSize: 10.0)),
        ],
      ),
    );
  }
}