import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/badge.dart';
import 'package:flutter_shop_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _isLoading = true;

    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.favorites) {
                setState(() {
                  _showOnlyFavorites = true;
                });
              } else {
                setState(() {
                  _showOnlyFavorites = false;
                });
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.favorites),
              const PopupMenuItem(
                  child: Text("Show All"), value: FilterOptions.all),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, child) => Badge(
              child: child as Widget,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            )
          : ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
