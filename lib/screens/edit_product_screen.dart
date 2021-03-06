import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../model/product.dart';

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
  final _form = GlobalKey<
      FormState>(); //rarely used, usually when you have to interact with a widget from inside your code (mostly with form widgets), it's a generic type and you need to tell it which data it will refer to, so it can hook into the state of that widget <FormState>
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );

  var _isLoading = false; //when true, will show loadingIndicator
  var _isInit = true; // change to false after line of code ran
  var _initValue = {
    //created to populate the screen when we come from Edit and not from Create
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(
        _updateImageUrl); //we will run the _updateImageUrl func when the focus is moved from _imageUrlFocusNode
  }

  @override
  void didChangeDependencies() {
    // will tun multiple times before the screen build; use this as we could not use ModalRoute in initState
    super.didChangeDependencies();
    if (_isInit) {
      //we wish to run this code only once, didChangeDep runs multiple times, hence this line of code
      final productId = ModalRoute.of(context).settings.arguments
          as String; //access the productId from previous screen, but we will have an argument only if page was loaded from editProduct and not from addProduct
      if (productId != null) {
        //only if we receive a productID (from edit)
        _editedProduct = Provider.of<Products>(context, listen: false).findById(
            productId); //listener false as we wish to listen only once when we get the prouct
        _initValue = {
          'title': _editedProduct.title,
          'descrition': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
          // 'imageUrl': _editedProduct.imageUrl //we can't add the value form here as we use controller in ImageUrl textField
        };
        _imageUrlController.text = _editedProduct
            .imageUrl; //we need to set the initialValue of the TextFormField for imageUrl using the controller
      }
      _isInit = false; //as we only wish to run once the code above
    }
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
    if (!_imageUrlFocusNode.hasFocus) {
      //if the focus (user tapped somewhere else) was moved from this textFormField, we rebuild the screen so we can see the image
      if ((!_imageUrlController.text.startsWith('http') ||
                  !_imageUrlController.text.startsWith('https')) &&
              (!_imageUrlController.text.endsWith('.png')) ||
          (!_imageUrlController.text.endsWith('.jpg')) ||
          (!_imageUrlController.text.endsWith('.jpeg'))) {
        return; //we set state (reload screen) only if link contains an immage
      }
     // setState(() {});
    }
    setState(() {});
  }

  Future<void> _saveForm() async {
     final _isValid = _form.currentState
        .validate(); //trigger all the validaters from the form
    //we run async code
    if (!_isValid) {
      return;
    }
    _form.currentState
        .save(); //this metod alows you to take and use the values entered in the TextFormFields (from the List) - access "onSaved" of each TextFormFields
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      //to avoid saving the edited item as a new one, if we have id, it means we only edit and not create a new one
      await Provider.of<Products>(context, listen: false) //await untill edited data is updated so it can be shown once screen is dismissed
          .updateProducts(_editedProduct.id, _editedProduct);

    } else {
      // else we add a new product
      //up to here code runs in time
      try {
        //after try, if code throws error, it can be catched
        await Provider.of<Products>(context,
                listen: false) //after await, code runs async, at the end
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          //we return (and not add this directly) as we don't wish to execute the other .then (close the screen) untill we press ok
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'), //show a title
            content:
                Text(error.toString()), //show the error code, can add anything
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  //button to close the aller
                  Navigator.of(context).pop(); //close the dialog alert
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } 
      // finally { //no longer requiered as we run the same code outside the if statement, and it wil run only after await is runned
      //   //used with try catch; always run no mather if there is an error
      //   setState(() {
      //     _isLoading = false; //before the screen quit
      //   });
      //   Navigator.of(context).pop(); //leave the page
      // }
    }
    setState(() {
        _isLoading = false; //before the screen quit
      });
      Navigator.of(context).pop(); //leave the page
    //used if Future.then is used, and not async .catchError((error) { //if we have an error, this is where we catch it, once it's thrown (by us) in the provider; for a good user experience
    //.then((_) {
    //then, as we wish to leave the page only once the product was added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  //backgroundColor: Theme.of(context).primaryColor,,
                  ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                //gives you acces to the values of the user Input (of TextFormField) without having to add your own textEditinControllers
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValue[
                          'title'], //this will be emty if we don't receive data from previous screen (we access the map _initValue, key title)
                      decoration: InputDecoration(
                        labelText: 'Title',
                        errorStyle: TextStyle(color: Colors.redAccent),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          //if user hasn't added a value
                          return 'Please add a Title'; //can be formated where Text Title is added (errorStyle)
                        }
                        return null; // = doesn't do anything
                      },
                      textInputAction: TextInputAction
                          .next, //what to show on the keyboard [ok btn] (next, new line)
                      onFieldSubmitted: (_) {
                        //action of the ok/done button from the keyboard
                        FocusScope.of(context).requestFocus(
                            _priceFocusNode); //we tell the cursore to jump to a different TextFormField when action btn from keybord press (in this case it wil jump to _priceFocusNode)
                      },
                      onSaved: (value) {
                        //this is communicating with _form.currentState.save()
                        _editedProduct = Product(
                            //we use the value (user text input) and save it in the product; all the other properties are unchanged, hence we need to add them as they are; we overwrite all of them them, as this is how the model was created; other option, to create a new model in this class
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: value,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please add a price';
                        }
                        if (double.tryParse(value) == null) {
                          //Double.tryParse(value) return a null if value is not double
                          return 'Please enter a valid number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Plese enter a number greater  than 0';
                        }
                        return null; //if we pass all these checkes, we return null/nothing
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode, // kind of a identifier**
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value),
                            imageUrl: _editedProduct.imageUrl);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['descrition'],
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.length < 10) {
                          return 'Please enter a description longer than 10 characters';
                        }
                        return null;
                      },
                      keyboardType: TextInputType
                          .multiline, //give a enter symbol on the keyboard
                      maxLines:
                          3, //no of lines shown on the screen (you can write more, but you will have to scroll to see them)
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
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
                            // initialValue: _initValue['imageUrl'], // we can't add initialValue from here if we have a controller in this TextFormatField, instead we set initial value form the controller
                            decoration: InputDecoration(hintText: 'Image Url'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please add a image URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return "This filed should only contain URL's";
                              }

                              if (!value.endsWith('.png') &&
                                  (!value.endsWith('.jpg')) &&
                                  (!value.endsWith('.jpeg'))) {
                                return 'The URL should contain an immage address';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller:
                                _imageUrlController, //we need to use the value before the form is subbmited, hence we add a controller (to use the value Inputed by user)
                            focusNode:
                                _imageUrlFocusNode, //in this case we add the focusNode to know when the user unselected this text field, for that we need a listener, added in the init state
                            onFieldSubmitted: (_) =>
                                _saveForm(), //when done btn from keybord is pressed (for this textFieldForm only)
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
