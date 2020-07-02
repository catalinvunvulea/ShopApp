import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/orders_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(
          orderData.orders[index],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
