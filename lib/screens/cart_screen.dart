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
                      '£ ${cart.totalAmount.toStringAsFixed(2)}', //toStringAsFixed(2) = show 2 decimals only
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER'),
      onPressed: (_isLoading || widget.cart.totalAmount <= 0) ? null : () async { //if the cart is emty, onPressed: null means the button is desabled
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder( //await because we want to change _isLoading to false and clear the cart only once the data is saved on the server
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clearCart(); //once the products are ordered, the cart is cleared 
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
