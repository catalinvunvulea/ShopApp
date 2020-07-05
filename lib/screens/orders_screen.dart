import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../provider/orders_provider.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget  {
  const OrdersScreen({Key key}) : super(key: key);

  static const routeName = '/orders-screen';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder( //read description
        future: Provider.of<Orders>(context, listen: false).setAndFetchOrders(), //data to expect
        builder: (ctx, dataReturnedByFuture) { //builder: context and the data received from future
          if (dataReturnedByFuture.connectionState == ConnectionState.waiting) { //connection state - can check if it is done, still waiting, etc and depending on the result, we can return widget on screen
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataReturnedByFuture.error != null) {
              return Center(
                child: Text('An error has occured'),
              );
            } else {
              if (dataReturnedByFuture.connectionState ==
                  ConnectionState.done) {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                      itemBuilder: (ctx, index) => OrderItem(
                            orderData.orders[index],
                          ),
                      itemCount: orderData.orders.length),
                );
              }
            }
          }
        },
      ),
    );
  }
}
