import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {
  final String status;
  const Bubble({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration:
          _cardBorders(status == 'completed' ? Colors.yellow : Colors.green),
    );
  }
}

BoxDecoration _cardBorders(color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]);
