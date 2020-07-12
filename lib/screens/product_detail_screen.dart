import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; //is the id!
    final loadedProduct = Provider.of<Products>(
      context,
      listen:
          false, //this will stop update of this widget every time when there is a change in the Products; it is not requiered in thuis case
    ).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        //animate the topest widget into a bar, when scrolling down
        slivers: <Widget>[
          //scollable areas on the screen
          SliverAppBar(
            expandedHeight:
                300, //the height that should have if it'snot the app bar but a widget (immage in our case )
            pinned:
                true, //app bar will always be visible and will not scroll out off the view
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                decoration: BoxDecoration(color: Colors.purple),
                child: Text(
                  loadedProduct.title,
                ),
              ),
              background: Hero(
                // used on the previous screen, and needs to be used here as well; use the same tag
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ), //what is inside the app barr and how it may change
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text(
                '£${loadedProduct.price}',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${loadedProduct.description}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  height:
                      800) // added only to make a longer screen to be able to see customScrollView (if description of the product would be longer)
            ]),
          ),
        ],
      ),
    );
  }
}
