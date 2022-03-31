import 'package:flutter/material.dart';
import 'package:frontend/services/pedidos_service.dart';
import 'package:frontend/widgets/bubble.dart';

class ProductCard extends StatelessWidget {
  final String idPedido;
  final String status;
  const ProductCard({Key? key, required this.idPedido, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: _cardBorders(),
      child: Stack(
        children: [
          Positioned(top: 15, left: 5, child: Bubble(status: status)),
          Text(idPedido)
        ],
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ]);
