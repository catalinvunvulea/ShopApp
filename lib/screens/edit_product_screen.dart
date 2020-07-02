import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const rotueName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode =
      FocusNode(); //object that can be used by statefull widgets to obtain keyboard focus and keybod events (like an identifier) / see where is called
  final _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose(); //once we leave the screen we always have to despose FocusNodes otherwise they will stick in the memory 
    _descriptionFocusNode.dispose();
  }

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
                      .next, //what to show on the keyboard [ok btn] (next, new line)
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
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType
                      .multiline, //give a enter symbol on the keyboard
                  maxLines:
                      3, //no of lines shown on the screen (you can write more, but you will have to scroll to see them)
                  focusNode: _descriptionFocusNode,
                ),
              ],
            ),
          ),
        ));
  }
}
