import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/auth.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_shop_app/screens/auth_screen.dart';
import 'package:flutter_shop_app/screens/cart_screen.dart';
import 'package:flutter_shop_app/screens/edit_product_screen.dart';
import 'package:flutter_shop_app/screens/orders_screen.dart';
import 'package:flutter_shop_app/screens/products_detail_screen.dart';
import 'package:flutter_shop_app/screens/products_overview_screen.dart';
import 'package:flutter_shop_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        //Set a provider which depends in another provider (in this case the Products providerdepends on Auth provider)
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (context) => Products("", "", []),
          // to get the token
          update: (context, authContainer, previousProducts) => Products(
              authContainer.token as String,
              authContainer.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          // we use create because we are creating a new instance (for better performance)
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders("", []),
          update: (context, authContainer, previousOrders) => Orders(
              authContainer.token as String,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: "MyShop",
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            fontFamily: 'Lato',
          ),
          // home: const ProductsOverviewScreen(),
          home:
              auth.isAuth ? const ProductsOverviewScreen() : const AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
