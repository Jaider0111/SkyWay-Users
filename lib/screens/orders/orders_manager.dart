import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/unauthorizedPage.dart';
import 'package:skyway_users/providers/orders_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/providers/users_provider.dart';
import 'package:skyway_users/models/collections/order.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/collections/user.dart';
import 'package:skyway_users/models/collections/store.dart';
import 'package:intl/intl.dart';

class OrdersManagerPage extends StatefulWidget {
  OrdersManagerPage({Key key}) : super(key: key);

  @override
  _OrdersManagerPageState createState() => _OrdersManagerPageState();
}

class _OrdersManagerPageState extends State<OrdersManagerPage> {
  bool ordersLoaded = false;
  List<OrderModel> ordersList = [];

  AuthProvider _authProvider;
  OrdersProvider _ordersProvider;
  ProductsProvider _productsProvider;
  String _type;

  final fCcy = new NumberFormat.simpleCurrency();

  @override
  Widget build(BuildContext context) {
    String _businessId;
    String _consumerId;

    _authProvider = BlocProvider.of<AuthProvider>(context);
    _ordersProvider = BlocProvider.of<OrdersProvider>(context);
    _productsProvider = BlocProvider.of<ProductsProvider>(context);
    _type = _authProvider.status;

    if (_type != "Tienda" && _type != "Usuario") {
      return UnauthorizedPage(info: "Ingresa con tu cuenta");
    }
    if (_type == "Tienda") {
      _businessId = _authProvider.shop.id;
      _consumerId = "";
    } else {
      _businessId = "";
      _consumerId = _authProvider.user.id;
    }
    if (!ordersLoaded) {
      loadOrders(_businessId, _consumerId);
      ordersLoaded = true;
    }
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child: _columnView(constraints),
          );
        },
      ),
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 16.0),
          child: Text(
              'Mis Órdenes',
              style:  TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
        ordersTable(constraints),
      ],
    );
  }

  Widget ordersTable(BoxConstraints constraints) {
    if (ordersList == null) return Container();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ordersList?.length,
        itemBuilder: (BuildContext context, int index) {
          return getOrderCard(ordersList[index]);
        });
  }

  Widget getOrderProduct(MapEntry<String, int> p) {
    ProductModel product;
    Future<ProductModel> future = getProductById(p.key);
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            product = snapshot.requireData;
            print(product);
            return Row(children: [
              SizedBox(width: 15),
              Text(
                  product.name,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
              ),
              SizedBox(width: 15),
              Text("${fCcy.format(product.price)}"),
              SizedBox(width: 15),
              Text("x${p.value}"),
              SizedBox(width: 15),
              Text(
                  "${fCcy.format(product.price * p.value)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  )
              ),
            ]);
          } else
            return Text("Cargando producto ...");
        });
  }

  Widget getOrderCard(OrderModel o) {
    UserModel user;
    StoreModel business;
    Future future = (_type == "Tienda") ? getUserById(o.consumerId) : getBusinessById(o.businessId);
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (_type == "Tienda")
              user = snapshot.requireData;
            else
              business = snapshot.requireData;
            print(business);
            print(user);
            return Container(
              width: 100,
              child: Card(
                  color: Color.fromARGB(255, 254, 225, 111),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children:[
                              Text(
                                  'Fecha y Hora:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.deepPurple,
                                  )
                              ),
                              SizedBox(width: 15),
                              Text(
                                  '${o.date.toString()}'
                              ),
                            ],
                          ),
                          Row(
                              children:[
                                (_type == "Tienda")
                                    ? Text(
                                    'Cliente:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.deepPurple,
                                    )
                                )
                                    : Text(
                                    'Vendedor:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.deepPurple,
                                    )
                                ),
                                SizedBox(width: 15),
                                (_type == "Tienda")
                                    ? Text('${user.fullName()}')
                                    : Text('${business.name}'),
                              ]
                          ),
                          Row(
                              children:[
                                Text(
                                    'Teléfono:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.deepPurple,
                                    )
                                ),

                                SizedBox(width: 15),
                                (_type == "Tienda")
                                    ? Text('${user.phone}')
                                    : Text('${business.phone}'),
                              ]
                          ),
                          Row(
                            children: [
                              Text(
                                  'Productos:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.deepPurple,
                                  )
                              ),
                            ],
                          ),
                          ListView.builder(
                              itemCount: o.products?.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return getOrderProduct(o.products.entries.elementAt(index));
                              }),
                          Row(
                            children:[
                              Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.deepPurple,
                                  )
                              ),
                              SizedBox(width: 15),
                              Text(
                                  '${fCcy.format(o.total)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  )
                              ),
                            ],
                          ),
                        ],
                      ))));

          } else
            return Text("Cargando orden ...");
        });
  }

  void loadOrders(String businessId, String consumerId) async {
    List orders = await _ordersProvider.getOrders(businessId, consumerId);
    print(orders.length);
    setState(() {
      orders.forEach((o) {
        OrderModel order = new OrderModel.fromJson(o);
        ordersList.add(order);
      });
    });
  }

  Future<ProductModel> getProductById(String id) async {
    ProductModel product = await _productsProvider.getProductById(id);
    return product;
  }

  Future<UserModel> getUserById(String id) async {
    UserModel user = await BlocProvider.of<UsersProvider>(this.context).getUserById(id);
    return user;
  }

  Future<StoreModel> getBusinessById(String id) async {
    StoreModel business = await BlocProvider.of<UsersProvider>(this.context).getBusinessById(id);
    print(business);
    return business;
  }
}
