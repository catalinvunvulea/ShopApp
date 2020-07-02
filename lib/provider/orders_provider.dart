import 'package:flutter/foundation.dart';

import '../model/cart.dart';
import '../model/orders.dart';

class Orders with ChangeNotifier {
  List<OrderItemM> _orders = [];

  List<OrderItemM> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemM> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItemM(
        id: DateTime.now().toString(),
        amount: total,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}