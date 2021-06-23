import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/collections/store.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/dashboard/dashboardBuyers.dart';
import 'package:skyway_users/screens/navigation_bar.dart';
import 'package:skyway_users/screens/unauthorizedPage.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  String _type;
  StoreModel _store;
  AuthProvider _provider;
  ProductsProvider _productsProvider;

  @override
  Widget build(BuildContext context) {
    _provider = BlocProvider.of<AuthProvider>(context);
    _productsProvider = BlocProvider.of<ProductsProvider>(context);
    _type = _provider.status;

    if (_type != "Usuario" && _type != "Tienda") {
      return UnauthorizedPage(
          info: "Por favor, inicia sesión en la aplicación");
    }
    _store = _provider.shop;
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child: Card(
              child: Row(
                children: [
                  NavBar(
                      width: constraints.maxWidth / 6.0,
                      height: constraints.maxHeight),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: Text(
                            'Mis Productos',
                            style: TextStyle(
                                fontSize: 40.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      "¿Deseas agregar un nuevo producto a tu tienda?")),
                              SizedBox(width: 20.0),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed('addProduct', arguments: {
                                    "businessId": _provider.shop.id,
                                  });
                                },
                                child: Text("Agregar Producto"),
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.bottomRight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<List<String>>(
                            future: _productsProvider
                                .searchProductsByBusinessId(_store.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final List<String> products =
                                    snapshot.requireData;
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 215.0,
                                    mainAxisExtent: 300.0,
                                  ),
                                  itemCount: products.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder<ProductModel>(
                                      future: _productsProvider
                                          .getProductById(products[index]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return DashboardProductWidget(
                                            onChange: () {
                                              setState(() {});
                                            },
                                            product: snapshot.requireData,
                                            toBuy: false,
                                          );
                                        }
                                        return SpinKitChasingDots(
                                          color: Colors.deepPurple,
                                          size: 60.0,
                                        );
                                      },
                                    );
                                  },
                                );
                              }
                              return SpinKitDualRing(
                                color: Colors.deepOrange,
                                size: 200.0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
