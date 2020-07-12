import 'package:flutter/material.dart';
import 'dart:math'; //gives us a min func
import 'package:intl/intl.dart'; //used for date formating (first need to add dependencies from https://pub.dev/packages/intl#-installing-tab-)

import '../model/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItemM order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(
              //like min in excel, need to import darth.math
              widget.order.products.length * 25 +
                  150.0, //we just give some values
              200.0,
            )
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('£ ${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                DateFormat('dd-MMMM-yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: EdgeInsets.all(10),
                height: _expanded
                    ? min(
                        //like min in excel, need to import darth.math
                        widget.order.products.length * 25 +
                            150.0, //we just give some values
                        200.0,
                      )
                    : 0,
                child: ListView(
                  //we use a ListView as we wish to scroll the products if the height of the ocntainer is too small
                  children: widget.order.products
                      .map(
                        (element) => Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(element.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )
                                  //fontStyle: FontStyle.italic),
                                  ),
                              Text(
                                '${element.quantity} x £${element.price}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
