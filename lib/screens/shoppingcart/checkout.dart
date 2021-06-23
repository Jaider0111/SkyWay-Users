import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:skyway_users/models/collections/order.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/navigation_bar.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:skyway_users/screens/appbar.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _address;
  String _indication;
  int _propina;
  String _cardNumber;
  int _cvv;
  int _month;
  int _year;
  int _pay;
  bool _creditCard;

  Map<ProductModel, int> _productsList;
  int _total;
  BoxConstraints _constraints;
  Map<String, List<ProductModel>> orders = {};

  @override
  void initState() {
    _creditCard = false;
    _total = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productsList =
        BlocProvider.of<ProductsProvider>(context).getProductsToBuy();
    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            _constraints = constraints;
            return BackgroundWidget(
              constraints: constraints,
              child: (constraints.maxWidth > 800.0)
                  ? _rowView(constraints)
                  : _columnView(constraints),
            );
          },
        ));
  }

  Widget _rowView(BoxConstraints constraints) {
    final width = constraints.maxWidth / 6.0;
    final height = constraints.maxHeight;
    return Card(
      child: Row(children: [
        NavBar(width: width, height: height),
        Expanded(
          child: Card(
            color: Colors.white60,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    "PRODUCTOS A COMPRAR",
                    style: TextStyle(fontSize: 25.0),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(child: productInList(_productsList, constraints)),
                ],
              ),
            ),
          ),
        ),
        Expanded(child: dataForm(constraints)),
      ]),
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return dataForm(constraints);
  }

  Widget productLine(ProductModel product, int cant) {
    final constraints = _constraints;
    final formatter =
        NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    final controller = TextEditingController(
      text: cant.toString(),
    );
    final children = [
      FadeInImage.assetNetwork(
        placeholder: "assets/images/loader.gif",
        image: product.images[0],
        width: min(200, constraints.maxWidth),
        height: min(200, constraints.maxWidth),
        fit: BoxFit.fitWidth,
      ),
      SizedBox(
        width: 20.0,
        height: 20.0,
      ),
      Expanded(
        child: SizedBox(
          height: 225.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name),
              Expanded(child: SizedBox()),
              Text(product.category),
              Expanded(child: SizedBox()),
              Text("Precio unidad: \$" + formatter.format(product.price)),
              Expanded(child: SizedBox()),
              Row(
                children: [
                  Text("Cantidad: " /*+ */),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: 110.0,
                    child: TextField(
                      onChanged: (val) {
                        int n = -1;
                        if (product.isCountable) n = product.amount;
                        if (n > int.tryParse(val) || n == -1)
                          BlocProvider.of<ProductsProvider>(context)
                              .setAmountof(product.id, int.tryParse(val));
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (BlocProvider.of<ProductsProvider>(context)
                                      .getAmountof(product.id) >
                                  1)
                                BlocProvider.of<ProductsProvider>(context)
                                    .deleteOneToProduct(product.id);
                            });
                          },
                          icon: Icon(Icons.remove),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              int n = -1;
                              if (product.isCountable) n = product.amount;
                              if (n > int.tryParse((controller.text)) ||
                                  n == -1)
                                BlocProvider.of<ProductsProvider>(context)
                                    .addOneToProduct(product.id);
                            });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    BlocProvider.of<ProductsProvider>(context)
                        .removeOfCart(product.id);
                  });
                },
                style: ElevatedButton.styleFrom(padding: EdgeInsets.all(5.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove),
                    SizedBox(width: 5.0),
                    Text('Eliminar del carrito'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: (constraints.maxWidth >= 600)
            ? Row(
                children: children,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              )
            : Column(children: children),
      ),
    );
  }

  Widget productInList(
      Map<ProductModel, int> list, BoxConstraints constraints) {
    final formatter =
        NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    orders = {};
    for (var key in list.keys) {
      if (orders.keys.contains(key.businessId))
        orders[key.businessId].add(key);
      else
        orders[key.businessId] = [key];
    }
    List o = orders.keys.toList();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orders.length,
        itemBuilder: (context, index) {
          int total = 0;
          orders[o[index]].forEach((element) {
            total += element.price * _productsList[element];
          });
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Orden ${index + 1}',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(height: 15.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: orders[o[index]].length,
                itemBuilder: (BuildContext context, int i) {
                  return productLine(orders[o[index]].elementAt(i),
                      list[orders[o[index]].elementAt(i)]);
                },
              ),
              SizedBox(height: 15.0),
              Text(
                'Total: ${formatter.format(total)}',
                style: TextStyle(fontSize: 25.0),
              ),
              SizedBox(height: 25.0),
            ],
          );
        });
  }

  Widget dataForm(BoxConstraints constraints) {
    _total = 0;
    _productsList.forEach((key, value) {
      _total += key.price * value;
    });
    final formatter =
        NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
    return Card(
      color: Colors.white70,
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: Scrollbar(
                isAlwaysShown: true,
                radius: Radius.elliptical(30.0, 30.0),
                thickness: 15.0,
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20.0),
                  children: [
                    AutoSizeText(
                      'Confirma tu pedido',
                      style: TextStyle(fontSize: 35.0),
                      minFontSize: 0.0,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    CustomInputText(
                        initialValue: "",
                        valueCallback: (val) => _name = val,
                        label: "¿Quién recibirá el pedido?",
                        icon: Icons.people,
                        validator: (val) => (val.length > 0)
                            ? null
                            : "Debes llenar este campo"),
                    CustomInputText(
                        initialValue: "",
                        valueCallback: (val) => _address = val,
                        label: "Ingresa la dirección:",
                        icon: Icons.house,
                        validator: (val) => (val.length > 0)
                            ? null
                            : "Debes llenar este campo"),
                    CustomInputText(
                        initialValue: "",
                        valueCallback: (val) => _indication = val,
                        label: "Piso/Apto:",
                        icon: Icons.location_city),
                    CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _propina = int.tryParse(val),
                      label: "Propina:",
                      icon: Icons.attach_money,
                    ),
                    AutoSizeText(
                      'Total: \$' + formatter.format(_total),
                      style: TextStyle(fontSize: 35.0),
                      minFontSize: 0.0,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    SwitchListTile(
                      value: _creditCard,
                      title: AutoSizeText(
                        "Pago con tarjeta",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _creditCard = val;
                        });
                      },
                    ),
                    (!_creditCard)
                        ? CustomInputText(
                            valueCallback: (val) => _pay = int.tryParse(val),
                            label: "Cantidad de efectivo con la que pagarás",
                            validator: (val) => (int.tryParse(val ?? "0") > 0)
                                ? null
                                : "Ingresa una cantidad valida",
                            initialValue: 0.toString(),
                            autovalidateMode: AutovalidateMode.disabled,
                            icon: Icons.money,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          )
                        : creditCard(constraints),
                    Center(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 80.0,
                        ),
                        ElevatedButton(
                          onPressed: doOrder,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.done),
                              SizedBox(width: 5.0),
                              Text("Hacer pedido"),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('shoppingCart');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart),
                              SizedBox(width: 5.0),
                              Text("Volver al carrito"),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget creditCard(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
            100.0,
        child: ListView(padding: EdgeInsets.all(30.0), children: [
          AutoSizeText(
            'Ingresa los datos de tu tarjeta',
            style: TextStyle(fontSize: 23.0),
            minFontSize: 0.0,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          CustomInputText(
            inputFormatters: [CreditCardNumberInputFormatter()],
            keyboardType: TextInputType.number,
            initialValue: "",
            valueCallback: (val) => _cardNumber = val,
            label: "Numero de tarjeta",
            icon: Icons.credit_card,
            validator: (val) => (val.length < 16 || val.length > 22)
                ? "Ingresa un numero de tarjeta valido"
                : null,
          ),
          CustomInputText(
            inputFormatters: [CreditCardCvcInputFormatter()],
            keyboardType: TextInputType.number,
            initialValue: "",
            valueCallback: (val) => _cvv = int.tryParse(val),
            label: "Codigo de seguridad",
            icon: Icons.lock,
            validator: (val) =>
                (val.length < 3) ? "Ingresa un CVC valido" : null,
          ),
          CustomInputText(
            inputFormatters: [CreditCardExpirationDateFormatter()],
            keyboardType: TextInputType.number,
            initialValue: "",
            valueCallback: (val) {
              if (val.length == 5) {
                _month = int.tryParse(val.substring(0, 2));
                _year = int.tryParse(val.substring(3, 5));
              }
            },
            label: "Fecha de vencimiento",
            icon: Icons.date_range,
            validator: (val) {
              if (val.length == 5) {
                final month = int.tryParse(val.substring(0, 2));
                final year = int.tryParse(val.substring(3, 5));
                final cyear = int.tryParse(
                    DateTime.now().year.toString().substring(2, 4));
                if (month < 1 || month > 12)
                  return "Ingresa un mes válido";
                else if (year < cyear) return "Ingresa un año válido";
                return null;
              } else
                return "Ingresa una fecha válida";
            },
          ),
        ]));
  }

  void doOrder() async {
    bool valid = validate();
    if (!valid) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("¿Estás seguro que quieres hacer el pedido?"),
            ],
          ),
          content: Text("Pulsa continuar para ordenar los pedidos"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cancel),
                  SizedBox(width: 10),
                  Text("Cancelar"),
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
                List<OrderModel> pedido = [];
                orders.forEach((key, value) {
                  pedido.add(OrderModel(
                    name: _name,
                    address: _address,
                    floorApto: _indication,
                    bonus: _propina,
                    date: DateTime.now(),
                    creditCard: _creditCard,
                    creditCardNumber: (_creditCard) ? _cardNumber : null,
                    cvv: (_creditCard) ? _cvv : null,
                    month: (_creditCard) ? _month : null,
                    year: (_creditCard) ? _year : null,
                    pay: (_creditCard) ? null : _pay,
                    products: _productsList
                        .map((key, value) => MapEntry(key.id, value)),
                    total: _total,
                    status: "paid",
                    consumerId:
                        BlocProvider.of<AuthProvider>(this.context).user.id,
                    businessId: key,
                  ));
                });
                int c = 0;

                bool savedOrder;
                pedido.forEach((element) async {
                  savedOrder = await BlocProvider.of<AuthProvider>(this.context)
                      .saveOrder(element);
                  if (savedOrder)
                    orders[element.businessId].forEach((element) {
                      BlocProvider.of<ProductsProvider>(this.context)
                          .removeOfCart(element.id);
                    });
                  else
                    c++;
                });

                Navigator.of(this.context).pop();
                if (c == 0)
                  messenger("El pedido se ha generado correctamente", 3);
                else if (c == pedido.length) {
                  messenger("Error al generar el pedido", 3);
                } else
                  messenger("Error al generar algunas órdenes", 2);
                setState(() {});
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
  }

  bool validate() {
    bool valid = _formKey.currentState.validate();
    if (!_creditCard && valid) {
      if (_pay < _total) {
        messenger("Debes ingresar un valor válido", 3);
        return false;
      }
      return valid;
    }
    if (valid && _productsList.length < 0) {
      messenger("TU carrito esta vacío, por favor agrega productos", 4);
      valid = false;
    }
    return valid;
  }

  void messenger(String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
