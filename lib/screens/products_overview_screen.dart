import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilteredOptions {
  Favourites, // =0
  All // = 1
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilteredOptions selectedValue) {
              if (selectedValue == FilteredOptions.Favourites) {
              //...do something
              } else {
              //...do something else
              }
            },
            color: Colors.yellow[50],
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show favourites'),
                value: FilteredOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilteredOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: ProductsGrid(),
    );
    return scaffold;
  }
}
