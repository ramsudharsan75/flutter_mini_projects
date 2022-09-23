import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<Item> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'flutter-practice-shop-cb3b9-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json', {
      'auth': authToken,
    });
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(res.body) as Map<String, dynamic>?;
    if (extractedData == null) return;

    extractedData.forEach((orderId, orderData) => {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map((item) => Item(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title']))
                  .toList(),
              dateTime: DateTime.parse(orderData['dateTime']),
            ),
          )
        });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Item> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-practice-shop-cb3b9-default-rtdb.europe-west1.firebasedatabase.app',
        'orders/$userId.json', {
      'auth': authToken,
    });
    final timestamp = DateTime.now();

    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }
}
