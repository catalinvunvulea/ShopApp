import 'package:flutter/material.dart';

import '../model/cart.dart';

class Cart with ChangeNotifier {
  Map<String, CartItemM> _items =
      {}; //it is initialised as emty for the addItem func to work (not to return a null)

  Map<String, CartItemM> get items {
    return {..._items}; //as it returns a map we use {}
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

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return; //don't do anything
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItemM(
          cartId: existingItem.cartId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      //using the key (in this case the id), we check if the Map already contains this product
      _items.update(
        //we update the existing product, we don't add another one
        productId, //use to identify the product
        (existingCartItem) => CartItemM(
          //everything remains the same but the qty increases by 1
          cartId: existingCartItem.cartId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId, //look up the product in the basket using the unique key (id)
        () => CartItemM(
          //putIfAbsent doesn't return just a value but a func that returns a value
          cartId: DateTime.now()
              .toString(), //we use the date to generate "unique" id for this product in the basket
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }
}
