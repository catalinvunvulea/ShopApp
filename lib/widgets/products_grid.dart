
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../widgets/product_item.dart';


class ProductsGrid extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final productsData =Provider.of<Products>(context); //it will check all his parrents if they have a ChangeNotifierProvider for Produccts, and we have on in main
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //chose how many columns to have on the screen, and they will be sized accordingly
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) => ProductItem(
        products[index].id,
        products[index].title,
        products[index].imageUrl,
       ),
      itemCount: products.length,
    );
  }
}