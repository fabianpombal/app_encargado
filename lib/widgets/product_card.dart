import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productosPedido;
  final bool status;
  const ProductCard(
      {Key? key, required this.productosPedido, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        width: 30,
        height: 60,
        decoration: _cardBorders(),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              "ID del pedido: $productosPedido",
              style: TextStyle(
                decoration:
                    status ? TextDecoration.lineThrough : TextDecoration.none,
                fontSize: 23,
                fontStyle: FontStyle.normal,
              ),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]);
