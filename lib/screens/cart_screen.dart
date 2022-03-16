import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart' show Cart;
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<Cart>(context);
    final ordersContainer = Provider.of<Orders>(context, listen: false);

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
                      label: Text(
                          '\$${cartContainer.totalAmount.toStringAsFixed(2)}'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    TextButton(
                        onPressed: () {
                          ordersContainer.addOrder(
                              cartContainer.items.values.toList(),
                              cartContainer.totalAmount);
                          cartContainer.clearCart();
                        },
                        child: const Text("ORDER NOW"))
                  ]),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartContainer.itemCount,
              itemBuilder: (context, index) => CartItem(
                  id: cartContainer.items.values.toList()[index].id,
                  price: cartContainer.items.values.toList()[index].price,
                  quantity: cartContainer.items.values.toList()[index].quantity,
                  title: cartContainer.items.values.toList()[index].title),
            ),
          )
        ],
      ),
    );
  }
}
