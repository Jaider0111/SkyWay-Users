import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/providers/products_provider.dart';

import '../appbar.dart';

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({Key key}) : super(key: key);

  @override
  ShoppingCartState createState() => ShoppingCartState();
}

class ShoppingCartState extends State<ShoppingCartPage> {
  Map<ProductModel, int> _productsList;

  bool _modify;
  ProductModel _productToModify;

  int n1;
  int n2;
  int _total = 0;
  int np;
  String _customerId;
  String _businessId;

  @override
  void initState() {
    _modify = false;
    super.initState();
    n1 = 0;
    n2 = 1;
    np = 0;

    _productsList = ProductsProvider().getProducts();

    /*{
      new ProductModel(
          name: "Producto",
          description: "description",
          category: "category",
          subcategory: "subcategory",
          businessId: "businessId",
          isCountable: false,
          price: 10000,
          isCustomizable: false,
          images: null): 1,
      new ProductModel(
          name: "Producto2",
          description: "description2",
          category: "categor2y",
          subcategory: "subcate2gory",
          businessId: "businessId2",
          isCountable: false,
          price: 20000,
          isCustomizable: false,
          images: null): 2,
      new ProductModel(
          name: "Producto3",
          description: "description3",
          category: "categor3y",
          subcategory: "subcate3gory",
          businessId: "businessId3",
          isCountable: false,
          price: 30000,
          isCustomizable: false,
          images: null): 2,
      new ProductModel(
          name: "Producto4",
          description: "description4",
          category: "category4",
          subcategory: "subcategory4",
          businessId: "businessI4d",
          isCountable: false,
          price: 10000,
          isCustomizable: false,
          images: null): 2,
      new ProductModel(
          name: "Producto5",
          description: "description5",
          category: "category5",
          subcategory: "subcategory5",
          businessId: "businessId5",
          isCountable: false,
          price: 10000,
          isCustomizable: false,
          images: null): 4,
    };
    for (var k in _productsList.keys) {
      print("-----------");
      print(k.price.toString);
      print(_productsList[k].toString);
      print("-----------");
      _total += (k.price) * _productsList[k];
    }
    for (var k in _productsList.keys) {
      np += _productsList[k];
    }*/
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    if (args.containsKey("customerId")) {
      _customerId = args["customerId"];
    } else {
      _customerId = "clienteprueba1";
    }
    if (args.containsKey("businessId")) {
      _businessId = args["businessId"];
    } else {
      _businessId = "negocioprueba1";
    }
    return Scaffold(
        appBar: appBar,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.deepPurple,
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  (constraints.maxWidth > 800.0)
                      ? _rowView(constraints, _productsList)
                      : _columnView(constraints, _productsList),
                ],
              );
            },
          ),
        ));
  }

  Widget _rowView(
      BoxConstraints constraints, Map<ProductModel, int> _productsLista) {
    if (_productsLista.length == 0)
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
        color: Colors.white,
        child: Text(
          "No tienes productos en tu carrito de compras",
          style: TextStyle(fontSize: 40.0),
        ),
      );
    if (_productsLista.length < 2)
      return Column(
        children: [
          Text(
            "CARRITO DE COMPRAS",
            style: TextStyle(fontSize: 50.0),
          ),
          Row(
            children: [
              Expanded(child: SizedBox()),
              Card(
                  child: productCard(
                      constraints, _productsLista.keys.elementAt(n1), n1)),
              if (_modify)
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: bigProductCard(constraints, _productToModify))
              else
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: goToCheckout(
                      constraints,
                    )),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    if (_productsLista.length < 3)
      return Column(
        children: [
          Text(
            "CARRITO DE COMPRAS",
            style: TextStyle(fontSize: 50.0),
          ),
          Row(
            children: [
              Expanded(child: SizedBox()),
              Card(
                  child: productCard(
                      constraints, _productsLista.keys.elementAt(n1), n1)),
              Card(
                  child: productCard(
                      constraints, _productsLista.keys.elementAt(n2), n2)),
              if (_modify)
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: bigProductCard(constraints, _productToModify))
              else
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: goToCheckout(
                      constraints,
                    )),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    else
      return Column(
        children: [
          Text(
            "CARRITO DE COMPRAS",
            style: TextStyle(fontSize: 50.0),
          ),
          Row(
            children: [
              Expanded(child: SizedBox()),
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () => backProduct(),
              ),
              Card(
                  child: productCard(
                      constraints, _productsLista.keys.elementAt(n1), n1)),
              Card(
                  child: productCard(
                      constraints, _productsLista.keys.elementAt(n2), n2)),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () => nextProduct(),
              ),
              if (_modify)
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: bigProductCard(constraints, _productToModify))
              else
                SizedBox(
                    height: (constraints.maxWidth > 800.0)
                        ? constraints.maxHeight - 80.0
                        : min(constraints.maxWidth, constraints.maxHeight),
                    width: (constraints.maxWidth > 800.0)
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth,
                    child: goToCheckout(
                      constraints,
                    )),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
  }

  void backProduct() {
    if (n1 > 0) {
      setState(() {
        n1--;
        n2--;
      });
    }
  }

  void nextProduct() {
    if (n1 < _productsList.length - 2) {
      setState(() {
        n1++;
        n2++;
      });
    }
  }

  Widget _columnView(
      BoxConstraints constraints, Map<ProductModel, int> _productsLista) {
    return productCard(constraints, _productsLista.keys.elementAt(n1), 0);
  }

  Widget productCard(
      BoxConstraints constraints, ProductModel product, int indexp) {
    return SizedBox(
        height: (constraints.maxWidth > 800.0)
            ? constraints.maxHeight / 2.0
            : min(constraints.maxWidth, constraints.maxHeight),
        width: (constraints.maxWidth > 800.0)
            ? constraints.maxWidth / 4.5
            : constraints.maxWidth,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              product.name,
              style: TextStyle(fontSize: 40.0),
            ),
            Text(
              product.category,
              style: TextStyle(fontSize: 33.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Precio unidad:",
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              "\$" + product.price.toString(),
              style: TextStyle(fontSize: 35.0),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Cant:" + _productsList[product].toString(),
              style: TextStyle(fontSize: 25.0),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => pullModify(product, indexp),
            ),
          ],
        ));
  }

  void pullModify(ProductModel product1, int indexpm) {
    setState(() {
      _modify = true;
      _productToModify = product1;
    });
  }

  Widget goToCheckout(BoxConstraints constraints) {
    return Card(
        color: Colors.white,
        child: Column(children: [
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "TOTAL",
            style: TextStyle(fontSize: 40.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "\$" + _total.toString(),
            style: TextStyle(fontSize: 36.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Numero de productos",
            style: TextStyle(fontSize: 32.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Text(
            np.toString(),
            style: TextStyle(fontSize: 40.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('checkout', arguments: {
                "listP": _productsList,
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments),
                SizedBox(width: 5.0),
                Text("Ir a pagar"),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('shoppingCart');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shop),
                SizedBox(width: 5.0),
                Text("Seguir comprando"),
              ],
            ),
          ),
        ]));
  }

  Widget bigProductCard(BoxConstraints constraints, ProductModel product) {
    return SizedBox(
      child: Card(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                product.name,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                product.description,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                product.category,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                product.subcategory,
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "\$" + product.price.toString(),
                style: TextStyle(fontSize: 40.0),
              ),
              Center(
                child: Row(children: [
                  Expanded(child: SizedBox()),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => remove(product),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    _productsList[product].toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => add(product),
                  ),
                  Expanded(child: SizedBox()),
                ]),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: Row(children: [
                  SizedBox(
                    width: 150.0,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => delete(product),
                  ),
                  IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () => cancel(),
                  ),
                ]),
              )
            ],
          )),
    );
  }

  void add(ProductModel productToAdd) {
    setState(() {
      _productsList[productToAdd]++;
    });
    _total = 0;
    for (var k in _productsList.keys) {
      print("-----------");
      print(k.price.toString);
      print(_productsList[k].toString);
      print("-----------");
      _total += (k.price) * _productsList[k];
    }
    np = 0;
    for (var k in _productsList.keys) {
      np += _productsList[k];
    }
  }

  void remove(ProductModel productToRemove) {
    setState(() {
      if (_productsList[productToRemove] > 0)
        _productsList[productToRemove]--;
      else
        delete(productToRemove);
    });
    _total = 0;
    for (var k in _productsList.keys) {
      print("-----------");
      print(k.price.toString);
      print(_productsList[k].toString);
      print("-----------");
      _total += (k.price) * _productsList[k];
    }
    np = 0;
    for (var k in _productsList.keys) {
      np += _productsList[k];
    }
  }

  void delete(ProductModel productToDelete) {
    bool f = true;
    Map<ProductModel, int> temp = {};
    setState(() {
      _modify = false;
      n1 = 0;
      n2 = 1;
      _productsList.remove(productToDelete);
    });
    _total = 0;
    for (var k in _productsList.keys) {
      print("-----------");
      print(k.price.toString);
      print(_productsList[k].toString);
      print("-----------");
      _total += (k.price) * _productsList[k];
    }
    np = 0;
    for (var k in _productsList.keys) {
      np += _productsList[k];
    }
  }

  void cancel() {
    bool f = true;
    setState(() {
      _modify = false;
    });
    if (!f) return;
  }
}
