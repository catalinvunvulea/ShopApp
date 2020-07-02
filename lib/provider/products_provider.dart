import 'package:flutter/material.dart';

import '../model/product.dart';

class Products with ChangeNotifier {
  //with = light enharitance; ChangeNotifier is built in the provider (added in pubspec, available https://pub.dev/packages/provider#-installing-tab-)

  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Bike',
      description: 'Great for excercice anywhere and anytime you want!',
      price: 549.99,
      imageUrl:'https://www.candncycles.co.uk/product_images/uploaded_images/hire-bike-surrey.jpg'
    ),
  ];

  var _showFavouritesOnly = false;

  List<Product> get items {
    // if (_showFavouritesOnly) {
    //   return _items
    //       .where((element) => element.isFavourie == _showFavouritesOnly)
    //       .toList();
    // }
    return [
      ..._items
    ]; //this is how we return a copy of the items = [...value ]
  }

  List<Product> get favouriteItems {
    return _items.where((element) => element.isFavourie).toList();
  }

  void addProducts() {
    // _items.add(value);
    notifyListeners();
  }
//comented as we should not set this globally
  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
