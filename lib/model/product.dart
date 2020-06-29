import 'package:flutter/foundation.dart'; //enable us to use @requiered

class Product {
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
}