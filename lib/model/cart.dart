import 'package:flutter/material.dart';

class CartItem {
  final String cartId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.cartId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}
