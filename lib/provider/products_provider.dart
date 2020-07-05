import 'package:flutter/material.dart';
import 'dart:convert'; //tools for converting data (ex: conver data into JSON JavaScriptObjectNotation - it's like  Map/Dicitonary)
import 'package:http/http.dart'
    as http; //every time when we access this class, we need to ad http. to avoid clashesh with pther func

import '../model/http_exception.dart';
import '../model/product.dart';

class Products with ChangeNotifier {
  //with = light enharitance; ChangeNotifier is built in the provider (added in pubspec, available https://pub.dev/packages/provider#-installing-tab-)

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
    // Product(
    //     id: 'p5',
    //     title: 'Bike',
    //     description: 'Great for excercice anywhere and anytime you want!',
    //     price: 549.99,
    //     imageUrl:
    //         'https://www.candncycles.co.uk/product_images/uploaded_images/hire-bike-surrey.jpg'),
  ];

  //var _showFavouritesOnly = false;

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
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    //returns  void Future, and async
    const url =
        'https://shopapp-9c0d8.firebaseio.com/products.json'; //url from where we wish to get the data
    try {
      //as the following code maight give an error
      final response = await http.get(
          url); //http only becaus we added "as http" in the import; get=get data from
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; //we receive from the server a Map of String(key) and a dynamic value (we know it's a map but is not always the case)
      final List<Product> loadedProducts = []; //create a emty list of Product
      extractedData.forEach((key, value) {
        //extractData = Map hence .forEach (key, value)
        loadedProducts.add(
          //we populate our product with the data from server
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            isFavourite: value['isFavourite'],
            imageUrl: value['imageUrl'],
          ),
        );
      });
      _items =
          loadedProducts; //items will now contain the data received from server
      notifyListeners();
    } catch (error) {
      throw (error); //in case we get one, throw so we can use it in the screen
    }
  }

  Future<void> addProduct(Product product) async {
    //instead of future we can use async, it will always return a future(this is <void>)
    //(if future used)to add a spinner once we add a new product, untill the data is available, we will return a Future
    const url = 'https://shopapp-9c0d8.firebaseio.com/products.json';
    try {
      //part of async, wrap the code that might fail to catch the error

      final response =
          await http //await is part of async; we are storing the response in a constant
              .post(
        //http(because we use as in the import), post = add something on database(firbase), url = location, body: json.encode ({ here we add a Map (can't add directly and object like Product )})
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavourite': product.isFavourite,
        }),
      );
      //this will run only if the above code succeed
      final newProduct = Product(
          title: product.title,
          price: product.price,
          description: product.description,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)[
              'name'] //response is the data saved, body is the name of the map created(unique name, like id)
          );
      //_items.insert(0, newProduct); // add product at the beginning of the list
      _items.add(newProduct); //add product at the end of the list
      notifyListeners();
    } catch (error) {
      //the code that will run when what is agter try throws an error
      throw (error); //we throw the error like we did when used catchError, to use it in the UserScreen
    }
    // .then((response) { - used with future //response = code after post; once response code is received (after the rest of code from app runs), the code after then runs
    //any code line after post will run, even if we don't receive a response from server; if we wait for something, we need to use .then(){and add here func to run once post is finalised}

    // }).catchError((error) {//used only with Future
    //   throw(error); //in this case we throw the error (if we have one) as we need to catch it in the EditProductScreen
    // });
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

  Future<void> updateProducts(String id, Product editedProduct) async {
    final prodIndex = _items.indexWhere((product) =>
        product.id ==
        id); //get the index where product.id = id received a parameter
    if (prodIndex > 0) {
      //we check to ensure we have a index (have found a product with that id), not requiered in our app
      final url =
          'https://shopapp-9c0d8.firebaseio.com/products/$id.json'; // adding / after product will dive further in the data base; we interpolate the id form the argument (hence url is no longer const but final)
      await http.patch(
          url, //patch = modify existing data on firebase; url = location, body = content
          body: json.encode({
            'title': editedProduct.title,
            'price': editedProduct.price,
            'description': editedProduct.description,
            'imageUrl': editedProduct.imageUrl,
            //'isFavourite': editedProduct.isFavourie,//if we don't add one of the lines in PATCH, it will stay the same, it won't get deleted
          }));
      _items[prodIndex] =
          editedProduct; //we overwrite the product from the certain index with the new one, which we edit
      notifyListeners();
    } else {
      //...
    }
  }

//this si called: OPTIMISTIC UPDATING  (deleting in our case) = re-update the product in we fail to delete from server
  Future<void> deleteProduct(String id) async {
    final url = 'https://shopapp-9c0d8.firebaseio.com/products/$id.json';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[
        existingProductIndex]; //before we delete, we store the item in this var
    _items.removeAt(existingProductIndex); //remove from the list
    final response = await http.delete(
        url); //unlike add and post, delete does not throw an error; hence we check if there is an error, what error, and then we take action accordingly
    if (response.statusCode >= 400) {
      //for delete, we need to check what error it was, and we need to build and throw our own exception
      _items.insert(existingProductIndex, existingProduct); //if we have an error, we restore the _items list using the info stored in the memory (var existingProduct )
      notifyListeners();
      throw HttpException('Could not delete product');
    } //try to delete from server; if it fails, we will have this thrown,  
    existingProduct =
        null; //if we succeed to delete the item from the server, we clear the product from the memory of the phone (this var) as well
    notifyListeners();
  }

//the below option would wor as well
  // void deleteProduct(String id) {
  //   final url = 'https://shopapp-9c0d8.firebaseio.com/products/$id.json';
  //   _items.removeWhere((element) => element.id == id);
  //   http.delete(url);
  //   notifyListeners();
  // }
}
