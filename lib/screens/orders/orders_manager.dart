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

    _authProvider = BlocProvider.of<AuthProvider>(context);
    _ordersProvider = BlocProvider.of<OrdersProvider>(context);
    _productsProvider = BlocProvider.of<ProductsProvider>(context);
    _type = _authProvider.status;

    if (_type != "Tienda") {
      return UnauthorizedPage(info: "Ingresa con tu cuenta de vendedor");
    }
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    if (args.containsKey("businessId"))
      _businessId = args["businessId"];
    else
      _businessId = "negocioDePrueba";
    if (!ordersLoaded) {
      loadOrders(_businessId);
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
            return (constraints.maxWidth > 800.0)
                ? _rowView(constraints)
                : _columnView(constraints);
          },
        ),
      ),
    );
  }
  Widget _rowView(BoxConstraints constraints) {
    return Row(
      children: [
        ordersTable(constraints)
      ],
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

    return DataTable(
      columns: [
        DataColumn(label: Text('Fecha y Hora')),
        DataColumn(label: Text('Cliente')),
        DataColumn(label: Text('Teléfono')),
        DataColumn(label: Text('Productos')),
        DataColumn(label: Text('Total')),
      ],
      rows:[for (var o in ordersList) DataRow(
        cells: [DataCell(Text(o.date.toString())),
                DataCell(Text(getUserById(o.consumerId).fullName())),
                DataCell(Text(getUserById(o.consumerId).phone)),
                DataCell(Expanded
                          (child: SingleChildScrollView
                            (child: Column
                              (mainAxisSize:MainAxisSize.min,
                                children:[for (var kp in o.products.keys) Text(getProductById(kp).name + " " + o.products[kp].toString())]
                              )
                            )
                          )
                        ),
                DataCell(Text(o.total.toString())),
        ]
      )],
    );
  }

  void loadOrders(String businessId) async {
    List orders = await BlocProvider.of<OrdersProvider>(this.context).getOrders(businessId);
    orders.forEach((o) {
      OrderModel order = new OrderModel.fromJson(o);
      ordersList.add(order);
    });
  }
  ProductModel getProductById(String id) {
    var p = BlocProvider.of<ProductsProvider>(this.context).getProductById(id);
    ProductModel product = new ProductModel.fromJson(p);
    return product;
  }

  UserModel getUserById(String id) {
    var u = BlocProvider.of<UsersProvider>(this.context).getUserById(id);
    UserModel user = new UserModel.fromJson(u);
    return user;
  }
}