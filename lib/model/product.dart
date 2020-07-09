import 'dart:convert';
import 'package:ShopApp/model/http_exception.dart';
import 'package:flutter/foundation.dart'; //enable us to use @requiered
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  //with = light enharitance; ChangeNotifier is built in the provider (added in pubspec, available https://pub.dev/packages/provider#-installing-tab-)
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});


//we use optimistic update = if the server doesn't get updated, we revert the value on the screen to it's initial value (ex: if we mark an item as favourite, if the server doesnt't get updated, we throw a error, and then revert the item as not favourite)
  Future<void> toggleFavouriteStatus(String token, String userId ) async {
    var oldStatus =
        isFavourite; //store the value in the momory, in case the server doeasn't get updated, to restore it
    isFavourite = !isFavourite;
    notifyListeners(); //inform all the listeners that are listening to this, that the parameter has changed
    final url = 'https://shopapp-9c0d8.firebaseio.com/userFavourites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
       // throw HttpException('Unable to upadte Favourite status!');
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}
