import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/product.dart';

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

  Product _editedProduct = Product(
    description: '',
    id: DateTime.now().toString(),
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
    _form.currentState?.save();
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
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
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (val) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              onSaved: (val) {
                _editedProduct = Product(
                  description: _editedProduct.description,
                  id: _editedProduct.id,
                  imageUrl: _editedProduct.imageUrl,
                  price: double.parse(val as String),
                  title: _editedProduct.title,
                );
              },
            ),
            TextFormField(
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
                );
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
                    decoration: const InputDecoration(labelText: "Image URL"),
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
                      );
                    },
                    focusNode: _imageUrlFocusNode,
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
