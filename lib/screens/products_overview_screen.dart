import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../provider/cart_provider.dart';
import './cart_screen.dart';
import '../provider/products_provider.dart';

enum FilteredOptions {
  Favourites, // =0
  All // = 1
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourite = false;
  var _isInit = true; //to avoid multiple run for code in  didChangeDependencies
  var _isLoading = false;

  @override
  void initState() {
    //initialState = before the pixels on the screen are built
    super.initState();
    // Provider.of<Products>(context).fetchAndSetProducts(); //this won't work here
    // Future.delayed(Duration.zero).then((_) => Provider.of<Products>(context).fetchAndSetProducts()); //this woud work but is better to use  didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    //called whenever a state is changing, but also at the beginning (with initState)
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        }); //this won't work in the initState; once we have received the data, we switch the loading to false
      });
    }
    setState(() {
      _isInit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilteredOptions selectedValue) {
              setState(() {
                if (selectedValue == FilteredOptions.Favourites) {
                  _showOnlyFavourite = true;
                } else {
                  _showOnlyFavourite = false;
                }
              });
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
          Consumer<Cart>(
            //use Consumer instead of Provider as we only wish to rebuid the child widget
            builder: (ctx, cart, childX) => Badge(
              //childX is the Consumer's child, and we use it as we don't want to rebuild the Icon because the Bedge is changing
              child: childX,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              //this is the child of the consumner (named ChildX by me)
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavourite),
    );
    return scaffold;
  }
}
