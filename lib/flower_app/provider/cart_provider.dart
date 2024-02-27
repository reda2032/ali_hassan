// cart_provider
import 'package:ali_hassan/flower_app/model/item.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List selectedProducts = [];

  double price = 0.0;

  add(Item product) {
    selectedProducts.add(product);
    price += product.price.round();
    notifyListeners();
  }

  delete(Item product) {
    selectedProducts.remove(product);
    price -= product.price.round();
    notifyListeners();
  }
}
