import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      //widget that remove child widget when swiped
      direction: DismissDirection
          .endToStart, //set the direction of the swipe from right(end) to left(start)
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          //widget to show a message/allert; returns a Future whenever the dialog is cloed
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            //backgroundColor: Colors.yellow[50],
            elevation: 10,
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(ctx).pop(false); //to close the dialog window and return; false, to return it to the confirmDismiss
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(ctx).pop(true); //true, as we wish to dismiss
                },
              )
            ],
          ),
        );
      },
      onDismissed: (dismissDirection) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text('£$price'),
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text('Total: £${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
    );
  }
}
