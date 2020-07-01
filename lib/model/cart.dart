import 'package:flutter/material.dart';

class CartItemM {
  final String cartId;
  final String title;
  final int quantity;
  final double price;

  CartItemM({
    @required this.cartId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}
