import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../widgets/cart_item.dart';
import '../provider/orders_provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Spacer(), //takes all the space available between widgets
                  Chip(
                    label: Text(
                      '£ ${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('ORDER'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clearCart(); //once the products are ordered, the cart is cleared 
                    },
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              // ListView doesn't know how much space to take, hence expanded will give all what is available
              child: ListView.builder(
            itemBuilder: (ctx, index) => CartItem(
              id: cart.items.values
                  .toList()[index]
                  .cartId, //we use values.toList as we access a Map(dictionary), and in the Map we need to access all the cartId and add them in a list(array), and then with the index pic the right value
              productId: cart.items.keys.toList()[index],
              title: cart.items.values.toList()[index].title,
              price: cart.items.values.toList()[index].price,
              quantity: cart.items.values.toList()[index].quantity,
            ),
            itemCount: cart.items
                .length, //or we can use the method created in the provider cart.itemsCount as we wish to show a cell for each qty
          ))
        ],
      ),
    );
  }
}
