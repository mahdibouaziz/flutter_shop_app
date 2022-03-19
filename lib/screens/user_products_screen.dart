import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/widgets/app_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = "/user-products";

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  bool _isLoading = true;

  Future<void> _refreshProducts(context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(filterByUser: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _refreshProducts(context).then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: productsContainer.items.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      UserProductItem(
                        id: productsContainer.items[index].id,
                        imageUrl: productsContainer.items[index].imageUrl,
                        title: productsContainer.items[index].title,
                        // title: productsContainer.items[index].title,
                      ),
                      const Divider()
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
