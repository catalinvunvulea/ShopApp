import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../model/product.dart';
import '../provider/cart_provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false); // listen = false => I am not interested to rebuilt the screen when changes occur
    
    return ClipRRect(
      //used to force borderRadius to all it's children
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>( //Consumer, like a provider, always listen to changes and will rebuild only what he returns => widget (shrink the area), unlike the Provider; add any widget to Consumer child and it won't change
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavourie ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                product.toggleFavouriteStatus();
              },
            ),
          ),
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
