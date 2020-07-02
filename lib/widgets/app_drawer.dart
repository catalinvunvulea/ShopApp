import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading:
                false, //won't show a button on the left (ex back button)
          ),
          Divider(), //horizontal line below the bar
          ListTile(
              leading: Icon(Icons.shop),
              title: const Text('Shop'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              }),
          Divider(), //horizontal line below the bar
          ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              }),
          Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage products '),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
