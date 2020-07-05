import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../provider/orders_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key key}) : super(key: key);

  static const routeName = '/orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

@override
  void initState() {
    Future.delayed(Duration.zero).then((_) { //this line of code is used (if we dont use didChangeDependencies - we should use this) as setAndFetchOrders returns a future, and initState runs only at the beginning and using this line of code it will wait for what is comming after then, and re-run
      Provider.of<Orders>(context, listen: false).setAndFetchOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(
          orderData.orders[index],
        ),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
