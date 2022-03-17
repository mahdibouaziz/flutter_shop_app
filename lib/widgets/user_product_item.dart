import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(
      {required this.id, required this.imageUrl, required this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () {
              Provider.of<Products>(context, listen: false).deleteProduct(id);
            },
          ),
        ]),
      ),
    );
  }
}
