import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/navigation_bar.dart';
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
  String _type;

  @override
  Widget build(BuildContext context) {
    String _businessId;
    String _consumerId;

    _authProvider = BlocProvider.of<AuthProvider>(context);
    _ordersProvider = BlocProvider.of<OrdersProvider>(context);
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
            child: Card(
              child: _columnView(constraints),
            ),
          );
        },
      ),
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return Row(
      children: [
        NavBar(width: constraints.maxWidth / 6.0, height: constraints.maxHeight),
        Expanded(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 16.0),
                  child: Text('Mis Órdenes',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Expanded(child: ordersTable(constraints)),
            ],
          ),
        ),
      ],
    );
  }

  Widget ordersTable(BoxConstraints constraints) {
    if (ordersList == null) return Container();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: ordersList?.length,
        itemBuilder: (BuildContext context, int index) {
          UserModel user;
          StoreModel business;
          Future future = (_type == "Tienda")
              ? getUserById(ordersList[index].consumerId, context)
              : getBusinessById(ordersList[index].businessId, context);
          return FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_type == "Tienda")
                    user = snapshot.requireData;
                  else
                    business = snapshot.requireData;
                  return Hero(
                    tag: 'orrpro$index',
                    child: OrderView(
                      type: _type,
                      o: ordersList[index],
                      business: business,
                      user: user,
                    ),
                  );
                } else
                  return SpinKitDualRing(color: Colors.cyan[200], size: 100.0);
              });
        });
  }

  Future<UserModel> getUserById(String id, BuildContext context) async {
    UserModel user = await BlocProvider.of<UsersProvider>(context).getUserById(id);
    return user;
  }

  Future<StoreModel> getBusinessById(String id, BuildContext context) async {
    StoreModel business = await BlocProvider.of<UsersProvider>(context).getBusinessById(id);
    print(business);
    return business;
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
}

class OrderView extends StatefulWidget {
  const OrderView(
      {Key key,
      @required String type,
      @required this.o,
      @required this.business,
      @required this.user})
      : _type = type,
        super(key: key);

  final String _type;
  final OrderModel o;
  final UserModel user;
  final StoreModel business;

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  bool seeMore;
  OrderModel o;

  @override
  void initState() {
    seeMore = false;
    o = widget.o;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fCcy = new NumberFormat.simpleCurrency(decimalDigits: 0);
    final fD = new DateFormat.yMd().add_jm();
    final title = TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: Colors.deepPurple,
        fontSize: 20.0);
    final body = TextStyle(fontSize: 20.0);
    String status;
    String nextStatus;
    String actionNext;
    bool isCancelable = false;
    switch (o.status) {
      case 'paid':
        status = 'Pedido confirmado';
        nextStatus = 'making';
        actionNext = 'Iniciar preparación';
        isCancelable = true;
        break;
      case 'making':
        status = 'En preparación';
        nextStatus = 'send';
        actionNext = 'Enviar producto';
        isCancelable = true;
        break;
      case 'send':
        status = 'En camino';
        nextStatus = 'delivered';
        actionNext = 'Marcar como Entregado';
        break;
      case 'delivered':
        status = 'Entregado';
        break;
      case 'cancel':
        status = 'Cancelado';
        break;
      default:
        status = 'Indefinido';
        break;
    }
    return Container(
      width: 100,
      child: Card(
        color: Colors.white70,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Fecha y Hora:',
                    style: title,
                  ),
                  SizedBox(width: 15),
                  Text(
                    '${fD.format(o.date)}',
                    style: body,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  (widget._type == "Tienda")
                      ? Text(
                          'Cliente:',
                          style: title,
                        )
                      : Text(
                          'Vendedor:',
                          style: title,
                        ),
                  SizedBox(width: 15),
                  (widget._type == "Tienda")
                      ? Text(
                          '${widget.user.fullName()}',
                          style: body,
                        )
                      : Text(
                          '${widget.business.name}',
                          style: body,
                        ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(children: [
                Text(
                  'Teléfono:',
                  style: title,
                ),
                SizedBox(width: 15),
                (widget._type == "Tienda")
                    ? Text(
                        '${widget.user.phone}',
                        style: body,
                      )
                    : Text(
                        '${widget.business.phone}',
                        style: body,
                      ),
              ]),
              SizedBox(
                height: 20.0,
              ),
              if (seeMore) ...[
                Text(
                  'Productos:',
                  style: title,
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListView.builder(
                  itemCount: o.products?.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OrdersProductsView(p: o.products.entries.elementAt(index)),
                        SizedBox(height: 5.0),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10.0),
              ],
              Row(
                children: [
                  Text(
                    'Total:',
                    style: title,
                  ),
                  SizedBox(width: 15),
                  Text('${fCcy.format(o.total)}',
                      style: body.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      )),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                children: [
                  Text(
                    'Estado:',
                    style: title,
                  ),
                  SizedBox(width: 15),
                  Text(
                    '$status',
                    style: body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        seeMore = !seeMore;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon((seeMore) ? Icons.arrow_upward : Icons.arrow_downward),
                        SizedBox(width: 10.0),
                        Text((seeMore) ? "Ver Menos" : "Ver Mas"),
                      ],
                    ),
                  ),
                  if (nextStatus != null && widget._type == 'Tienda')
                    ElevatedButton(
                      onPressed: () async {
                        String actual = o.status;
                        o.status = nextStatus;
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Text("¿Deseas continuar con la actualizacion de estado?"),
                                ],
                              ),
                              content: Text(
                                  "Pulsa continuar para actualizar la orden o atras para no hacerlo"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.cancel),
                                      SizedBox(width: 10),
                                      Text("Atras"),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          children: [
                                            SpinKitPouringHourglass(
                                              color: Colors.deepOrange,
                                              size: 150,
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    bool save =
                                        await BlocProvider.of<OrdersProvider>(context).update(o);

                                    Navigator.of(this.context).pop();
                                    if (save)
                                      messenger(
                                          "Se actualizo la orden correctamente", 3, this.context);
                                    else {
                                      messenger("Error al cancelar la orden", 2, this.context);
                                      o.status = actual;
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.navigate_next),
                                      SizedBox(width: 10),
                                      Text("Continuar"),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.navigate_next),
                          SizedBox(width: 10.0),
                          Text(actionNext),
                        ],
                      ),
                    ),
                  if (isCancelable)
                    ElevatedButton(
                      onPressed: () async {
                        String actual = o.status;
                        o.status = 'cancel';
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Text("¿Realmente deseas cancelar la orden?"),
                                ],
                              ),
                              content: Text(
                                  "Pulsa continuar para cancelar la orden o atras para no hacerlo"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.cancel),
                                      SizedBox(width: 10),
                                      Text("Atras"),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          children: [
                                            SpinKitPouringHourglass(
                                              color: Colors.deepOrange,
                                              size: 150,
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    bool save =
                                        await BlocProvider.of<OrdersProvider>(context).update(o);

                                    Navigator.of(this.context).pop();
                                    if (save)
                                      messenger(
                                          "Se cancelo la orden correctamente", 3, this.context);
                                    else {
                                      messenger("Error al cancelar la orden", 2, this.context);
                                      o.status = actual;
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.navigate_next),
                                      SizedBox(width: 10),
                                      Text("Continuar"),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cancel_outlined),
                          SizedBox(width: 10.0),
                          Text('Cancelar Orden'),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdersProductsView extends StatelessWidget {
  const OrdersProductsView({
    Key key,
    @required this.p,
  }) : super(key: key);

  final MapEntry<String, int> p;

  @override
  Widget build(BuildContext context) {
    final body = TextStyle(fontSize: 16.0);
    final fCcy = new NumberFormat.simpleCurrency(decimalDigits: 0);
    ProductModel product;
    Future<ProductModel> future = getProductById(p.key, context);
    return FutureBuilder(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<ProductModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            product = snapshot.requireData;
            return Row(children: [
              SizedBox(width: 20.0),
              SizedBox(
                width: 220,
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 100.0,
                child: Text(
                  "${fCcy.format(product.price)}",
                  style: body,
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 50.0,
                child: Text(
                  "x${p.value}",
                  style: body,
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 100.0,
                child: Text(
                  "${fCcy.format(product.price * p.value)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ]);
          } else
            return Center(
              child: SpinKitCircle(
                color: Colors.black,
                size: 40.0,
              ),
            );
        });
  }

  Future<ProductModel> getProductById(String id, BuildContext context) async {
    final ProductsProvider _productsProvider = BlocProvider.of<ProductsProvider>(context);
    ProductModel product = await _productsProvider.getProductById(id);
    return product;
  }
}
