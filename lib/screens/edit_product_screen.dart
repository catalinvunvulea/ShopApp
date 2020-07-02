import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {

  static const rotueName = '/edit-product-screen';
  
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit title'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction
                      .next, //controlls the action of button from the keyoard as an ok, next, done. submit etc
                ),
              ],
            ),
          ),
        ));
  }
}
