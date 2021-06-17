import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/models/collections/order.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';

import '../appbar.dart';

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

  @override
  void initState() {
    _creditCard = false;
    _total = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _productsList = BlocProvider.of<ProductsProvider>(context).getProducts();
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
                  (constraints.maxWidth > 800.0) ? _rowView(constraints) : _columnView(constraints),
                ],
              );
            },
          ),
        ));
  }

  Widget _rowView(BoxConstraints constraints) {
    return Row(children: [
      Expanded(child: SizedBox()),
      Column(
        children: [
          Text(
            "PRODUCTOS A COMPRAR",
            style: TextStyle(fontSize: 20.0),
          ),
          productInList(_productsList, constraints),
        ],
      ),
      dataForm(constraints),
      Expanded(child: SizedBox()),
    ]);
  }

  Widget _columnView(BoxConstraints constraints) {
    return dataForm(constraints);
  }

  Widget productLine(ProductModel product, int cant) {
    return Card(
      child: Row(
        children: [
          SizedBox(
            width: 20.0,
          ),
          Text(product.name),
          Expanded(child: SizedBox()),
          Text(product.category),
          Expanded(child: SizedBox()),
          Text("Unidad: \$" + product.price.toString()),
          Expanded(child: SizedBox()),
          Text("Cantidad: " + cant.toString()),
          Expanded(child: SizedBox()),
          SizedBox(
            width: 20.0,
          ),
        ],
      ),
    );
  }

  Widget productInList(Map<ProductModel, int> list, BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width:
            ((constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth) -
                100.0,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 100.0,
                child: productLine(list.keys.elementAt(index), list[list.keys.elementAt(index)]));
          },
        ));
  }

  Widget dataForm(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 100.0,
        width:
            ((constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth) -
                100.0,
        child: Form(
            key: _formKey,
            child: Scrollbar(
                isAlwaysShown: true,
                radius: Radius.elliptical(30.0, 30.0),
                thickness: 15.0,
                child: ListView(padding: EdgeInsets.all(20.0), children: [
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
                          validator: (val) =>
                              (int.tryParse(val ?? "0") > 0) ? null : "Ingresa una cantidad valida",
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
                ]))));
  }

  Widget creditCard(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width:
            ((constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth) -
                100.0,
        child: Form(
            key: _formKeycc,
            child: ListView(padding: EdgeInsets.all(30.0), children: [
              AutoSizeText(
                'Ingresa los datos de tu tarjeta',
                style: TextStyle(fontSize: 23.0),
                minFontSize: 0.0,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _cardNumber = val,
                label: "Numero de tarjeta",
                icon: Icons.credit_card,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _cvv = int.tryParse(val),
                label: "Codigo de seguridad",
                icon: Icons.lock,
              ),
              AutoSizeText(
                'Fecha de vencimiento',
                style: TextStyle(fontSize: 15.0),
                minFontSize: 0.0,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _month = int.tryParse(val),
                label: "Mes",
                icon: Icons.date_range,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _year = int.tryParse(val),
                label: "Año",
                icon: Icons.date_range,
              ),
            ])));
  }

  void doOrder() async {
    bool valid = validate();

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
                      customerId: _customerId,
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
                      customerId: _customerId,
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
    if (!_creditCard) {
      if (_pay < _total) {
        messenger("Debes ingresar un valor valido", 3);
        return false;
      }
      return valid;
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