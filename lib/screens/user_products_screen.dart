import 'package:ShopApp/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../provider/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    //as this is not in a statefull widget, and not in build, we need to pass argument BuildCOntext to use it below;
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.rotueName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        //returns a future, shows a spinner indicator by default;
        onRefresh: () => _refreshProducts(
            context), //we need to tell it when to stop showing the spinner; returns a future and we build the method accordingly
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (ctx, index) => UserProducItem(
              productsData.items[index].title,
              productsData.items[index].imageUrl,
              productsData.items[index].id,
            ),
          ),
        ),
      ),
    );
  }
}
