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

  Future<void> addOrder(List<CartItemM> cartProducts, double total) async {
    const url =
        'https://shopapp-9c0d8.firebaseio.com/orders.json'; //ading /orders creates a new node/folder(if not created already) on firebase (other servers may work different)
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
}
