import 'dart:io';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService extends ChangeNotifier {
  final String _baseUrl =
      "lpro-6c2f9-default-rtdb.europe-west1.firebasedatabase.app";
  final List<Producto> products = [];
  bool isLoading = true;

  ProductService() {
    this.loadProducts();
  }

  Future<List<Producto>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'productos.json');
    final res = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(res.body);
    print(json.decode(res.body));
    productsMap.forEach((key, value) {
      final tempProduct = Producto.fromMap(value);
      tempProduct.id = key;
      this.products.add(tempProduct);
    });
    print(this.products);
    isLoading = false;
    notifyListeners();

    return this.products;
  }
}
