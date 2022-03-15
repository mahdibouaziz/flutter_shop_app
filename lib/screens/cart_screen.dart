import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    const Spacer(),
                    Chip(
                      label: Text('\$${cartContainer.totalAmount}'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    TextButton(onPressed: () {}, child: const Text("ORDER NOW"))
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
