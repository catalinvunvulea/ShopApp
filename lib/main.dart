import 'package:ShopApp/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //enable us to set a provider

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './provider/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(), //now we have an instance of Products class which applyes to all it's child and his children (MaterialApp is the child - the route of the app, but extends to it's children, who can now also have listeners)
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
        },
      ),
    );
  }
}
