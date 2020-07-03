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
  final _imageUrlController =
      TextEditingController(); //we need acces to the user input Url to see the picture (before the form is submited; once the form is submitted, we would have acces without this controller)
  final _imageUrlFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl); //we will run the _updateImageUrl func when the focus is moved from _imageUrlFocusNode

  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode
        .dispose(); //once we leave the screen we always have to despose FocusNodes otherwise they will stick in the memory
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) { //if the focus (user tapped somewhere else) was moved from this textFormField, we rebuild the screen so we can see the image
    setState(() {
    });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit product'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            //gives you acces to the values of the user Input (of TextFormField) without having to add your own textEditinControllers
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
                Row(
                  // has an unconstrainer width
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Center(child: Text('Enter a URL'))
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        //takes all the available width, and as it is in a row, we need to wrap in Expanded
                        decoration: InputDecoration(hintText: 'Image Url'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller:
                            _imageUrlController, //we need to use the value before the form is subbmited, hence we add a controller (to use the value Inputed by user)
                        focusNode: _imageUrlFocusNode, //in this case we add the focusNode to know when the user unselected this text field, for that we need a listener, added in the init state
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
