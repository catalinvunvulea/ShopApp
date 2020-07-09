import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //enable us to set a provider

import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import 'package:ShopApp/provider/auth.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './provider/products_provider.dart';
import './provider/cart_provider.dart';
import './provider/orders_provider.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';

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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>( //ProxyProvider alows you to set a provider which iteslf depends on another provider whihc was defined before this one (code before, like Auth) <Auth - data from where you provide, Products - data where you provide)
            update: (ctx, auth, previousProducts) => Products(auth.token, auth.userId, previousProducts == null ? [] : previousProducts.items), //now we have an instance of Products class which applyes to all it's child and his children (MaterialApp is the child - the route of the app, but extends to it's children, who can now also have listeners)
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(auth.token, previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            //we would us child for a widget that we don't want to rebuild
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(), // if we are authenticated, we shot the ProductOS otherwie the AuthScreen
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.rotueName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
