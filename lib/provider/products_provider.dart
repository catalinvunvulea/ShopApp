import 'package:flutter/material.dart';
import 'dart:convert'; //tools for converting data (ex: conver data into JSON JavaScriptObjectNotation - it's like  Map/Dicitonary)
import 'package:http/http.dart'
    as http; //every time when we access this class, we need to ad http. to avoid clashesh with pther func

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
        imageUrl:
            'https://www.candncycles.co.uk/product_images/uploaded_images/hire-bike-surrey.jpg'),
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

  Future<void> addProduct(Product product) {//to add a spinner once we add a new product, untill the data is available, we will return a Future
     const url = 'https://shopapp-9c0d8.firebaseio.com/products.json';
    return http
        .post(
      //http(because we use as in the import), post = add something on database(firbase), url = location, body: json.encode ({ here we add a Map (can't add directly and object like Product )})
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavourite': product.isFavourie,
      }),
    )
        .then((response) { //response = code after post; once response code is received (after the rest of code from app runs), the code after then runs
      //any code line after post will run, even if we don't receive a response from server; if we wait for something, we need to use .then(){and add here func to run once post is finalised}
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'] //response is the data saved, body is the name of the map created(unique name, like id)
          );
      //_items.insert(0, newProduct); // add product at the beginning of the list
      _items.add(newProduct); //add product at the end of the list
      notifyListeners();
    }).catchError((error) {
      throw(error); //in this case we throw the error (if we have one) as we need to catch it in the EditProductScreen
    });
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

  void updateProducts(String id, Product editedProduct) {
    final prodIndex = _items.indexWhere((product) =>
        product.id ==
        id); //get the index where product.id = id received a parameter
    if (prodIndex > 0) {
      //we check to ensure we have a index (have found a product with that id), not requiered in our app
      _items[prodIndex] =
          editedProduct; //we overwrite the product from the certain index with the new one, which we edit
    } else {
      //...
    }
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
