import 'package:flutter/material.dart';

class Item {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Item({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, Item> _items = {};

  Map<String, Item> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (cartItem) => Item(
              id: cartItem.id,
              title: cartItem.title,
              quantity: cartItem.quantity + 1,
              price: cartItem.price));
    } else {
      _items.putIfAbsent(
        productId,
        () => Item(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => Item(
                id: existingCartItem.id,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
                title: existingCartItem.title,
              ));

      // _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
