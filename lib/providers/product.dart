import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop_app/models/http_exception.dart';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.description,
      this.id,
      required this.imageUrl,
      required this.price,
      required this.title,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String token) async {
    final dbUrl1 = Uri.parse(
        "https://flutter-course-536b7-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token");

    isFavorite = !isFavorite;
    notifyListeners();

    final response = await http.patch(dbUrl1,
        body: json.encode({
          'isFavorite': isFavorite,
        }));

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException("Failed to turn this product into favorites");
    }
  }
}
