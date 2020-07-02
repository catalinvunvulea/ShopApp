import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const rotueName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode =
      FocusNode(); //object that can be used by statefull widgets to obtain keyboard focus and keybod events
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
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    //action of the ok/done button from the keyboard
                    FocusScope.of(context).requestFocus(
                        _priceFocusNode); //we tell the cursore to jump to a different TextFormField when action btn from keybord press (in this case it wil jump to _priceFocusNode)
                  },
                ), //controlls the action  button (only the display, not the aciton yet)from the keyoard as an ok, next, done. submit etc
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode, // kind of a identifier**
                ),
              ],
            ),
          ),
        ));
  }
}
