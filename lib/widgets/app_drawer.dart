import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../provider/auth.dart';
import '../helpers/custom_route.dart';

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
                // Navigator.of(context).pushReplacement(
                //   CustomRoute(
                //     builder: (ctx) => OrdersScreen(),
                //   ),
                // );
              }),
          Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Manage products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
