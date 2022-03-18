import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';

import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Orders with ChangeNotifier {
  final dbUrl = Uri.parse(
      "https://flutter-course-536b7-default-rtdb.europe-west1.firebasedatabase.app/orders.json");

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get totalCount {
    return _orders.length;
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();

    final response = await http.post(
      dbUrl,
      body: json.encode({
        'amount': total,
        'datetime': timestamp.toIso8601String(),
        "products": cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'title': cp.title,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );

    notifyListeners();
  }
}
