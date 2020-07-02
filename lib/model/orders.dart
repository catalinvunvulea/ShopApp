import 'package:flutter/foundation.dart';

import '../model/cart.dart';


class OrderItemM {
  final String id;
  final double amount;
  final List<CartItemM> products;
  final DateTime dateTime;

  OrderItemM({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}