import 'package:flutter/material.dart';
import 'package:frontend/services/pedidos_service.dart';
import 'package:frontend/widgets/bubble.dart';

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
              width: 20,
            ),
            Bubble(status: status),
            const SizedBox(
              width: 10,
            ),
            Text(
              "ID del pedido: $productosPedido",
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold),
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
