import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; //enable to use add, post, delete etc
import 'dart:convert'; //enable to convert jsons

import '../model/cart.dart';
import '../model/orders.dart';

class Orders with ChangeNotifier {
  List<OrderItemM> _orders = [];

  List<OrderItemM> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  Future<void> addOrder(List<CartItemM> cartProducts, double total) async {
    final url =
        'https://shopapp-9c0d8.firebaseio.com/orders/$userId.json?auth=$authToken'; //ading /orders creates a new node/folder(if not created already) on firebase (other servers may work different)
    final timeStampe = DateTime
        .now(); //store it here as we wish to have the same date locally and on the server
    final response = await http.post(
      url,
      body: json.encode({
        //body is a list [of objects: amount, dateTime, products - which is a objec(map) - and we define it using the same elements]
        'amount': total,
        'dateTime': timeStampe
            .toIso8601String(), //very precise date, easy to convert back once received fomr server
        'products': cartProducts
            .map((cartItem) => {
                  'id': cartItem.cartId,
                  'title': cartItem.title,
                  'price': cartItem.price,
                  'quantity': cartItem.quantity,
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItemM(
        id: json.decode(response.body)[
            'name'], //acces the id from firebase; it is set to 'name' by default
        amount: total,
        dateTime: timeStampe,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> setAndFetchOrders() async {
    final url = 'https://shopapp-9c0d8.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItemM> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String,
        dynamic>; //data received form server, decoded using json, we tell it that is a Map with a string as the key, and the value is dynamic (can be anything, we have a list of Maps, and one of the keys(producs) nest as well a list of maps )
    if (extractedData == null) {
      return; //we will stop the code if the extractedData == null (no orders on server) else we get an error
    }
    extractedData.forEach((orderId, orderData) {
      //orderId = key, orderData = value
      loadedOrders.add(OrderItemM(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItemM(
                cartId: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList(); // reversed.toList(); to show the latest on top
    notifyListeners();
  }
}
