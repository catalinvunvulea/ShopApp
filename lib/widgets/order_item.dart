import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //used for date formating (first need to add dependencies from https://pub.dev/packages/intl#-installing-tab-)

import '../model/orders.dart';

class OrderItem extends StatelessWidget {
  final OrderItemM order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('£ ${order.amount}'),
          ),
        ],
      ),
    );
  }
}
