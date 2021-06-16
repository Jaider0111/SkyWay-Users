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
            return _columnView(constraints);
          },
        ),
      ),
    );
  }

  Future<Widget> _rowView(BoxConstraints constraints) async {
    return Row(
      children: [await ordersTable(constraints)],
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
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
              Text(product.name),
              SizedBox(width: 15),
              Text("${product.price}"),
              SizedBox(width: 15),
              Text("${p.value}"),
              SizedBox(width: 15),
              Text("${product.price * p.value}"),
            ]);
          } else
            return Text("Cargando producto ...");
        });
  }

  Widget getOrderCard(OrderModel o) {
    UserModel user;
    StoreModel business;
    Future<dynamic> future =
        (_type == "Tienda") ? getUserById(o.consumerId) : getBusinessById(o.businessId);
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
            return Card(
                child: Column(
              children: [
                Text('Fecha y Hora: ${o.date.toString()}'),
                (_type == "Tienda")
                    ? Text('Cliente: ${user.fullName()}')
                    : Text('Vendedor: ${business.name}'),
                (_type == "Tienda")
                    ? Text('Teléfono: ${user.phone}')
                    : Text('Teléfono: ${business.phone}'),
                Text('Productos'),
                ListView.builder(
                    itemCount: o.products?.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return getOrderProduct(o.products.entries.elementAt(index));
                    }),
                Text('Total: ${o.total}'),
              ],
            ));
          } else
            return Text("Cargando orden ...");
        });
  }

  void loadOrders(String businessId, String consumerId) async {
    List orders =
        await BlocProvider.of<OrdersProvider>(this.context).getOrders(businessId, consumerId);
    setState(() {
      orders.forEach((o) {
        OrderModel order = new OrderModel.fromJson(o);
        ordersList.add(order);
      });
    });
  }

  Future<ProductModel> getProductById(String id) async {
    ProductModel product = await BlocProvider.of<ProductsProvider>(this.context).getProductById(id);
    return product;
  }

  Future<UserModel> getUserById(String id) async {
    UserModel user = await BlocProvider.of<UsersProvider>(this.context).getUserById(id);
    return user;
  }

  Future<StoreModel> getBusinessById(String id) async {
    StoreModel business = await BlocProvider.of<UsersProvider>(this.context).getBusinessById(id);
    return business;
  }
}
