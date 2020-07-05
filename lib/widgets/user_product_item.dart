import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProducItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProducItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = Scaffold.of(context); //store it here as we will use it in a future and this is the only way we can
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.rotueName,
                      arguments: id,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  color: Theme.of(context).errorColor,
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false).deleteProduct(
                          id); //or else, we could pass in a func and call the provider in the user_producScreen

                    } catch (error) {
                      scaffoldContext.showSnackBar(SnackBar(
                        content: Text(
                          'Deleting faield!',
                        ),
                      ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
