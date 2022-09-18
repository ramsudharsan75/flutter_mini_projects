import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models//http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void setFavorite(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.https(
        'flutter-practice-shop-cb3b9-default-rtdb.europe-west1.firebasedatabase.app',
        'products/$id.json');
    bool? oldStatus = isFavorite;
    setFavorite(!isFavorite);
    notifyListeners();

    try {
      final res = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (res.statusCode >= 400) {
        throw HttpException('Favorite status is not changed');
      }
    } catch (err) {
      setFavorite(oldStatus);
      rethrow;
    }

    oldStatus = null;
  }
}
