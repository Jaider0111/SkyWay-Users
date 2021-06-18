import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/navigation_bar.dart';

class DashBoard2Page extends StatefulWidget {
  DashBoard2Page({Key key}) : super(key: key);

  @override
  _DashBoard2PageState createState() => _DashBoard2PageState();
}

class _DashBoard2PageState extends State<DashBoard2Page> {
  bool load = false;
  List<ProductModel> lista = [];
  List<ProductModel> alimentos = [];
  List<ProductModel> restaurantes = [];
  List<ProductModel> farmacia = [];
  List<ProductModel> otros = [];
  AuthProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = BlocProvider.of<AuthProvider>(context);
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return BackgroundWidget(
          constraints: constraints,
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Card(
                color: Colors.white38,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    sideBar(constraints),
                    Expanded(child: bigPanel(constraints)),
                  ],
                )),
          ),
        );
      }),
    );
  }

  Widget sideBar(BoxConstraints constraints) {
    if (!load) {
      loadProducts();
      load = true;
    }
    final width = constraints.maxWidth / 6.0;
    final height = constraints.maxHeight;
    return NavBar(width: width, height: height);
  }

  Widget bigPanel(BoxConstraints constraints) {
    return SizedBox(
        height: 736.0,
        child: Column(
          children: [
            header(constraints),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
                child: Scrollbar(
                  isAlwaysShown: false,
                  radius: Radius.elliptical(30.0, 30.0),
                  thickness: 10.0,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          Expanded(child: menuCategory(constraints)),
                          Expanded(child: referAFriendWidget(constraints)),
                        ],
                      ),
                      productsView(constraints, lista),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget header(BoxConstraints constraints) {
    return SizedBox(
      height: 736.0 / 6.0,
      child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: searchWidget(constraints)),
                Row(children: [
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    heroTag: 'notification',
                    backgroundColor: Colors.white38,
                    onPressed: () {},
                    child: Image(
                      width: 40.0,
                      image: AssetImage("assets/images/bell2.png"),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    heroTag: 'cart',
                    backgroundColor: Colors.white38,
                    onPressed: () {
                      Navigator.of(context).pushNamed('checkout');
                    },
                    child: Image(
                      image: AssetImage("assets/images/shopping-cart.png"),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  FloatingActionButton(
                    heroTag: 'user',
                    backgroundColor: Colors.white38,
                    onPressed: () {},
                    child: Image(
                      image: AssetImage("assets/images/user.png"),
                    ),
                  ),
                ]),
              ],
            ),
          )),
    );
  }

  Widget menuCategory(BoxConstraints constraints) {
    return SizedBox(
      height: 736.0 / 6.0 * 1.9,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white70,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              categoryWidget(constraints, "Alimentos", "diet.png", alimentos),
              categoryWidget(constraints, "Restaurantes", "cutlery.png", restaurantes),
              categoryWidget(constraints, "Farmacia", "medicine.png", farmacia),
              categoryWidget(constraints, "Otros", "settings.png", otros),
            ],
          ),
        ),
      ),
    );
  }

  Widget referAFriendWidget(BoxConstraints constraints) {
    return SizedBox(
      height: 736.0 / 6.0 * 1.9,
      child: Card(
          elevation: 10.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 736.0 / 6.0 * 1.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Refiere a un amigo y obtén \$10.000 COPS.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Itim",
                            fontSize: 736.0 / 30.0,
                          ),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Colors.blue,
                          onPressed: () {},
                          label: Text(
                            "¡Referir!",
                            style: TextStyle(fontSize: 736.0 / 30.0, fontFamily: "Itim"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: SizedBox(
                      height: 736.0 / 6.0 * 1.9,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/stonks.jpg"), fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }

  Widget productsView(BoxConstraints constraints, List<ProductModel> list) {
    print(list.length);
    return SizedBox(
      height: 736.0 / 6.0 * 2.7,
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        color: Colors.white70,
        child: Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return DashboardProductWidget(
                product: list[index],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget categoryWidget(BoxConstraints constraints, name, image, List<ProductModel> list) {
    return Container(
      height: 736.0 / 6.0 * 1.9 - 20.0,
      width: 736.0 / 6.0 * 1.9 - 20.0,
      child: InkWell(
        onTap: () {
          setState(() {
            lista = list;
          });
        },
        child: Card(
            color: Colors.white,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10.0),
                  SizedBox(
                      height: (736.0 / 6.0 * 1.9 - 20.0) / 2.3,
                      width: (736.0 / 6.0 * 1.9 - 20.0) / 2.3,
                      child: Image(
                        image: AssetImage("assets/images/" + image),
                      )),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Itim",
                      fontSize: (736.0 / 6.0 * 1.9 - 20.0) / 10.8,
                    ),
                  ),
                ],
              ),
            ))),
      ),
    );
  }

  Widget searchWidget(BoxConstraints constraints) {
    return Hero(
      tag: 'searchBar',
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed('search'),
        child: SizedBox(
          width: 736.0 / 6.0 * 4.8 / 1.5,
          child: Theme(
            data: ThemeData(fontFamily: "Itim", primaryColor: Colors.black),
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(30.0)),
              child: Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: TextFormField(
                  enabled: false,
                  style: TextStyle(fontSize: 20.0),
                  onChanged: (null),
                  decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      border: InputBorder.none,
                      fillColor: Colors.grey,
                      focusColor: Colors.grey,
                      focusedBorder: null,
                      labelText: "Ingresa el nombre del producto o restaurante que buscas ...",
                      labelStyle: TextStyle(fontSize: 20.0),
                      contentPadding: EdgeInsets.only(bottom: 15.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sideBarButton(BoxConstraints constraints, name, IconData icon, route) {
    return TextButton(
      onPressed: () {
        if (route == "login") {
          _provider.logout();
          Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
        } else {
          Navigator.of(context).pushNamed(route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            SizedBox(width: 5.0),
            Text(name,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Itim",
                  fontSize: 1536.0 / 65.0,
                )),
          ],
        ),
      ),
    );
  }

  void loadProducts() async {
    List products = await BlocProvider.of<ProductsProvider>(this.context).getProducts();
    products.forEach((product) {
      ProductModel newProduct = new ProductModel.fromJson(product);
      if (newProduct.category == "Alimentos") {
        alimentos.add(newProduct);
        alimentos.toSet();
      } else if (newProduct.category == "Restaurantes") {
        restaurantes.add(newProduct);
      } else if (newProduct.category == "Farmacia") {
        farmacia.add(newProduct);
      } else if (newProduct.category == "Varios") {
        otros.add(newProduct);
      }
    });
    setState(() {
      lista = alimentos;
    });
  }

  randomGn(int a, int b) {
    var rng = new Random();
    return ((b - a) * rng.nextDouble() + a);
  }
}

class DashboardProductWidget extends StatefulWidget {
  const DashboardProductWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  final ProductModel product;

  @override
  _DashboardProductWidgetState createState() => _DashboardProductWidgetState();
}

class _DashboardProductWidgetState extends State<DashboardProductWidget> {
  ProductsProvider _productProvider;
  bool isInCart;

  @override
  Widget build(BuildContext context) {
    _productProvider = BlocProvider.of<ProductsProvider>(context);
    isInCart = _productProvider.isInCart(widget.product.id);
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    double precio = widget.product.price.toDouble();
    return Container(
      height: 736.0 / 6.0 * 1.9 - 20.0,
      width: 736.0 / 6.0 * 1.9 - 20.0,
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.white,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: (736.0 / 6.0 * 1.9 - 20.0) * 2.0 / 3.0,
                  width: (736.0 / 6.0 * 1.9 - 20.0) * 2.0 / 3.0,
                  child: Image(
                    image: NetworkImage(widget.product.images[0]),
                  ),
                ),
                RatingBarIndicator(
                  rating: widget.product.stars,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: (736.0 / 6.0 * 1.9 - 20.0) * 1.0 / 8.0,
                  direction: Axis.horizontal,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.product.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Itim",
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$${formatter.format(precio)}",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Itim",
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(width: 5.0),
                    SizedBox(
                      height: 25.0,
                      width: 25.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            if (isInCart)
                              _productProvider.removeOfCart(widget.product.id);
                            else
                              _productProvider.addToCart(widget.product, 1);
                          });
                        },
                        mini: true,
                        backgroundColor: (isInCart) ? Colors.red : Colors.green,
                        child: Icon((isInCart) ? Icons.remove : Icons.add),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ))),
    );
  }
}
