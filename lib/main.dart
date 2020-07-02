import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //enable us to set a provider

import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './provider/products_provider.dart';
import './provider/cart_provider.dart';
import './provider/orders_provider.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //enable us to have multiple ChangeNotifierProvider (listeners for different providers anywhere in the app (anywhere as we have tis in Main))
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              Products(), //now we have an instance of Products class which applyes to all it's child and his children (MaterialApp is the child - the route of the app, but extends to it's children, who can now also have listeners)
        ),
        ChangeNotifierProvider( 
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.rotueName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
