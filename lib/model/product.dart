import 'package:flutter/foundation.dart'; //enable us to use @requiered

class Product with ChangeNotifier{ //with = light enharitance; ChangeNotifier is built in the provider (added in pubspec, available https://pub.dev/packages/provider#-installing-tab-)
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourie;


Product({
@required this.id,
@required this.title,
@required this.description,
@required this.price,
@required this.imageUrl,
this.isFavourie = false
});

void toggleFavouriteStatus() {
  isFavourie = !isFavourie;
  notifyListeners(); //inform all the listeners that are listening to this, that the parameter has changed
}

}