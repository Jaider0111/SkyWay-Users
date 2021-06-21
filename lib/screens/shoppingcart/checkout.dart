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
  final _formKeycc = GlobalKey<FormState>();
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
  List<String> _opts = [];
  Map<String, List<String>> _options = Map();
  String _customerId;
  String _businessId;

  Map<ProductModel, int> _productsList;
  int _total;
  BoxConstraints _constraints;

  @override
  void initState() {
    _creditCard = false;
    _total = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productsList = BlocProvider.of<ProductsProvider>(context).getProductsToBuy();
    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            _constraints = constraints;
            return BackgroundWidget(
              constraints: constraints,
              child:
                  (constraints.maxWidth > 800.0) ? _rowView(constraints) : _columnView(constraints),
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
    final formatter = NumberFormat.currency(decimalDigits: 0, symbol: '', locale: 'es_CO');
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
          height: min(200, constraints.maxWidth),
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
                    width: 90.0,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                        suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      ),
                    ),
                  ),
                ],
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

  Widget productInList(Map<ProductModel, int> list, BoxConstraints constraints) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return productLine(list.keys.elementAt(index), list[list.keys.elementAt(index)]);
      },
    );
  }

  Widget dataForm(BoxConstraints constraints) {
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
                        label: "Quien recibirá el pedido?",
                        icon: Icons.people,
                        validator: (val) => (val.length > 0) ? null : "Debes llenar este campo"),
                    CustomInputText(
                        initialValue: "",
                        valueCallback: (val) => _address = val,
                        label: "Ingresa la dirección",
                        icon: Icons.house,
                        validator: (val) => (val.length > 0) ? null : "Debes llenar este campo"),
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
                      'Total: \$' + _total.toString(),
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
                            label: "Cantidad de efectivo con la que pagaras",
                            validator: (val) => (int.tryParse(val ?? "0") > 0)
                                ? null
                                : "Ingresa una cantidad valida",
                            initialValue: 0.toString(),
                            icon: Icons.money,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly])
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
        width:
            ((constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth) -
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
            validator: (val) =>
                (val.length < 16 || val.length > 22) ? "Ingresa un numero de tarjeta valido" : null,
          ),
          CustomInputText(
            inputFormatters: [CreditCardCvcInputFormatter()],
            keyboardType: TextInputType.number,
            initialValue: "",
            valueCallback: (val) => _cvv = int.tryParse(val),
            label: "Codigo de seguridad",
            icon: Icons.lock,
            validator: (val) => (val.length < 3) ? "Ingresa un CVC valido" : null,
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
                final cyear = int.tryParse(DateTime.now().year.toString().substring(2, 4));
                if (month < 1 || month > 12)
                  return "Ingresa un mes valido";
                else if (year < cyear) return "Ingresa un año valido";
                return null;
              } else
                return "Ingresa una fecha valida";
            },
          ),
        ]));
  }

  void doOrder() async {
    bool valid = validate();
    if (!valid) return;

    _opts.forEach((element) {
      if (!_options.containsKey(element)) _options[element] = [];
    });
    if (!valid) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Estas seguro que quieres hacer el pedido"),
            ],
          ),
          content: Text("Pulsa continuar para ordenar el pedido"),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Row(
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
                OrderModel pedido;
                if (!_creditCard) {
                  pedido = OrderModel(
                      id: _address + _indication,
                      name: _name,
                      address: _address,
                      floorApto: _indication,
                      bonus: _propina,
                      date: DateTime.now(),
                      creditCard: _creditCard,
                      creditCardNumber: null,
                      cvv: null,
                      month: null,
                      year: null,
                      pay: _pay,
                      products: _productsList.map((key, value) => MapEntry(key.id, value)),
                      total: _total,
                      status: "open",
                      consumerId: _customerId,
                      businessId: _businessId);
                } else {
                  pedido = OrderModel(
                      id: _address + _indication,
                      name: _name,
                      address: _address,
                      floorApto: _indication,
                      bonus: _propina,
                      date: DateTime.now(),
                      creditCard: _creditCard,
                      creditCardNumber: _cardNumber,
                      cvv: _cvv,
                      month: _month,
                      year: _year,
                      pay: null,
                      products: _productsList.map((key, value) => MapEntry(key.id, value)),
                      total: _total,
                      status: "open",
                      consumerId: _customerId,
                      businessId: _businessId);
                }

                String savedOrder =
                    await BlocProvider.of<AuthProvider>(this.context).saveOrder(pedido);

                Navigator.of(this.context).pop();
                if (savedOrder == "El pedido no se ha generado correctamente")
                  messenger("El pedido no se ha generado correctamente", 3);
                else if (savedOrder != null) {
                  messenger("Pedido Recibido", 3);
                } else
                  messenger("Error al hacer el pedido", 2);
              },
              child: Row(
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
    print("$valid-1");
    if (!_creditCard && valid) {
      print("$valid-2");
      if (_pay < _total) {
        messenger("Debes ingresar un valor valido", 3);
        print("$valid-3");
        return false;
      }
      print("$valid-4");
      return valid;
    }
    print("$valid-5");
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
