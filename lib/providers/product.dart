import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  late final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.description,
      required this.id,
      required this.imageUrl,
      required this.price,
      required this.title,
      this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
