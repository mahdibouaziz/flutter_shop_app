import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';
import 'package:flutter_shop_app/providers/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _initValues = {
    'title': "",
    'description': "",
    'price': "",
    // 'imageUrl': "",
  };

  bool _isLoading = false;
  bool isInit = true;

  Product _editedProduct = Product(
    description: '',
    id: null,
    imageUrl: '',
    price: 0,
    title: '',
  );

  @override
  void initState() {
    super.initState();

    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      isInit = false;
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        final _editedProduct = Provider.of<Products>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() {
    final isValid = _form.currentState?.validate() as bool;
    if (!isValid) {
      return;
    }

    _form.currentState?.save();

    setState(() {
      _isLoading = true;
    });

    if (_initValues['title'] != "") {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      final productContainer = Provider.of<Products>(context, listen: false);

      // to keep the favorite status
      final oldProduct = productContainer.findById(productId);
      _editedProduct.isFavorite = oldProduct.isFavorite;

      productContainer.updateProduct(productId, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        print("inside catch");
        return showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("An error occured"),
            content: const Text("Something went wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("Okay"),
              )
            ],
          ),
        );
      }).then((value) {
        print("Inside then");
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//loading widget
    final spinkit = SpinKitRotatingCircle(
      color: Theme.of(context).colorScheme.secondary,
      size: 100.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create / Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: spinkit,
            )
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _form,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: const InputDecoration(labelText: "Title"),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (val) {
                      _editedProduct = Product(
                        description: _editedProduct.description,
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        title: val as String,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    validator: (val) {
                      // if we return a null => this is a valid
                      // if we return a text this is our error message
                      if (val!.isEmpty) {
                        return "Please provide a value";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'],
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (val) {
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onSaved: (val) {
                      _editedProduct = Product(
                        description: _editedProduct.description,
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(val as String),
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    validator: (val) {
                      // if we return a null => this is a valid
                      // if we return a text this is our error message
                      if (val!.isEmpty) {
                        return "Please provide a value";
                      }
                      if (double.tryParse(val) == null) {
                        return 'Please enter a valid number';
                      }
                      if (double.parse(val) <= 0) {
                        return 'Please neter a valid price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['description'],
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNode,
                    onSaved: (val) {
                      _editedProduct = Product(
                        description: val as String,
                        id: _editedProduct.id,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                        title: _editedProduct.title,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? const Text(
                                "Enter a Url",
                                textAlign: TextAlign.center,
                              )
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _initValues['imageUrl'],
                          decoration:
                              const InputDecoration(labelText: "Image URL"),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          onEditingComplete: () {
                            setState(() {});
                          },
                          onFieldSubmitted: (val) {
                            saveForm();
                          },
                          onSaved: (val) {
                            _editedProduct = Product(
                              description: _editedProduct.description,
                              id: _editedProduct.id,
                              imageUrl: val as String,
                              price: _editedProduct.price,
                              title: _editedProduct.title,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                          focusNode: _imageUrlFocusNode,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please provide a value";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
    );
  }
}
