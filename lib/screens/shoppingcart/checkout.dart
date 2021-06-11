import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/models/collections/order.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/collections/user.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';

import '../appbar.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key key}) : super(key: key);

  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeycc = GlobalKey<FormState>();
  String _Name;
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

  List<ProductModel> _productsList;
  int _total = 0;

  @override
  void initState() {
    _creditCard = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    if (args.containsKey("listP")) {
      _productsList = args["listP"];
      for (int i = 0; i < _productsList.length; i++) {
        _total += _productsList[i].price;
      }
    } else {
      _productsList = [
        new ProductModel(
            name: "Producto",
            description: "description",
            category: "category",
            subcategory: "subcategory",
            businessId: "businessId",
            isCountable: false,
            price: 10000,
            isCustomizable: false,
            images: null),
        new ProductModel(
            name: "Producto2",
            description: "description2",
            category: "categor2y",
            subcategory: "subcate2gory",
            businessId: "businessId2",
            isCountable: false,
            price: 20000,
            isCustomizable: false,
            images: null),
        new ProductModel(
            name: "Producto3",
            description: "description3",
            category: "categor3y",
            subcategory: "subcate3gory",
            businessId: "businessId3",
            isCountable: false,
            price: 30000,
            isCustomizable: false,
            images: null),
        new ProductModel(
            name: "Producto4",
            description: "description4",
            category: "category4",
            subcategory: "subcategory4",
            businessId: "businessI4d",
            isCountable: false,
            price: 10000,
            isCustomizable: false,
            images: null),
        new ProductModel(
            name: "Producto5",
            description: "description5",
            category: "category5",
            subcategory: "subcategory5",
            businessId: "businessId5",
            isCountable: false,
            price: 10000,
            isCustomizable: false,
            images: null),
      ];
      for (int i = 0; i < _productsList.length; i++) {
        _total += _productsList[i].price;
      }
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
                      ? _rowView(constraints)
                      : _columnView(constraints),
                ],
              );
            },
          ),
        ));
  }

  Widget _rowView(BoxConstraints constraints) {
    return Row(children: [
      productInList(_productsList, constraints),
      DataForm(constraints)
    ]);
  }

  Widget _columnView(BoxConstraints constraints) {
    return DataForm(constraints);
  }

  Widget productLine(ProductModel product) {
    return Card(
      child: Row(
        children: [
          Text(product.name),
          Expanded(child: SizedBox()),
          Text(product.category),
          Expanded(child: SizedBox()),
          Text("\$" + product.price.toString())
        ],
      ),
    );
  }

  Widget productInList(List<ProductModel> list, BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
            100.0,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(height: 100.0, child: productLine(list[index]));
          },
        ));
  }

  Widget DataForm(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 100.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
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
                      valueCallback: (val) => _Name = val,
                      label: "Quien recibirá el pedido?",
                      icon: Icons.people,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _address = val,
                      label: "Ingresa la dirección",
                      icon: Icons.house,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
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
                          inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ])
                      : creditCard(constraints),
                  Center(
                      child: Row(
                    children: [
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
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('shoppingCart');
                        },
                        child: Text("Volver al carrito de compras"),
                      ),
                    ],
                  )),
                ]))));
  }

  Widget creditCard(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
            100.0,
        child: Form(
            key: _formKeycc,
            child: ListView(padding: EdgeInsets.all(30.0), children: [
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
                style: TextStyle(fontSize: 35.0),
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
                orderModel pedido;
                if (!_creditCard) {
                  pedido = orderModel(
                      orderId: _address + _indication,
                      name: _Name,
                      address: _address,
                      floorApto: _indication,
                      bonus: _propina,
                      creditCard: _creditCard,
                      creditCardNumber: null,
                      cvv: null,
                      month: null,
                      year: null,
                      pay: _pay,
                      order: _productsList,
                      price: _total);
                } else {
                  pedido = orderModel(
                      orderId: _address + _indication,
                      name: _Name,
                      address: _address,
                      floorApto: _indication,
                      bonus: _propina,
                      creditCard: _creditCard,
                      creditCardNumber: _cardNumber,
                      cvv: _cvv,
                      month: _month,
                      year: _year,
                      pay: null,
                      order: _productsList,
                      price: _total);
                }

                String savedOrder =
                    await BlocProvider.of<AuthProvider>(this.context)
                        .saveOrder(pedido);

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
