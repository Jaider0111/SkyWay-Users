import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/models/collections/categories.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/providers/products_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/images_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/screens/unauthorizedPage.dart';

class AddProductPage extends StatefulWidget {
  AddProductPage({Key key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  String _category;
  String _subcategoty;
  String _businessId;
  bool _isCountable;
  int _amount;
  int _price;
  bool _isCustomizable;
  List<String> _opts = [];
  List<bool> _enabledFilds = [];
  List<Uint8List> _images = [];
  Map<String, List<String>> _options = Map();
  AuthProvider _authProvider;
  ProductsProvider _productsProvider;
  String _type;

  @override
  void initState() {
    _isCountable = false;
    _isCustomizable = false;
    _category = BlocProvider.of<AuthProvider>(context).shop?.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = BlocProvider.of<AuthProvider>(context);
    _productsProvider = BlocProvider.of<ProductsProvider>(context);
    _type = _authProvider.status;
    if (_type != "Tienda") {
      return UnauthorizedPage(info: "Ingresa con tu cuenta de vendedor");
    }
    _businessId = _authProvider.shop.id;
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child:
                (constraints.maxWidth > 800.0) ? _rowView(constraints) : _columnView(constraints),
          );
        },
      ),
    );
  }

  Widget _rowView(BoxConstraints constraints) {
    return Row(
      children: [
        ImagesView(
          multiImage: true,
          title: "Muestranos tu producto",
          updateImages: (imgs) => _images = imgs,
          isWeb: kIsWeb,
          height: constraints.maxHeight,
          width: constraints.maxWidth / 2.0,
        ),
        productForm(constraints)
      ],
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        ImagesView(
          multiImage: true,
          title: "Muestranos tu producto",
          updateImages: (imgs) => _images = imgs,
          isWeb: kIsWeb,
          height: min(constraints.maxWidth, constraints.maxHeight),
          width: constraints.maxWidth,
        ),
        productForm(constraints),
      ],
    );
  }

  Widget productForm(BoxConstraints constraints) {
    return SizedBox(
      height: (constraints.maxWidth > 800.0)
          ? constraints.maxHeight
          : min(constraints.maxWidth, constraints.maxHeight),
      width: (constraints.maxWidth > 800.0) ? constraints.maxWidth / 2.0 : constraints.maxWidth,
      child: Form(
        key: _formKey,
        child: Scrollbar(
          isAlwaysShown: true,
          radius: Radius.elliptical(30.0, 50.0),
          thickness: 15.0,
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: [
              AutoSizeText(
                'Registra tu nuevo producto',
                style: TextStyle(fontSize: 35.0),
                minFontSize: 0.0,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.0),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _name = val,
                label: "Nombre del Producto",
                icon: Icons.food_bank_rounded,
                validator: (val) => (val.length > 0) ? null : "Ingresa un nombre",
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _description = val,
                label: "Describe tu producto",
                icon: Icons.description_rounded,
                maxLines: 5,
                validator: (val) => (val.length > 0) ? null : "Ingresa una descripción",
              ),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => (val != null) ? null : "Selecciona una categoria",
                value: _category,
                style: Theme.of(context).textTheme.bodyText1,
                elevation: 10,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  labelText: "Categoria",
                ),
                items: categories
                    .map((e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _category = val;
                    _subcategoty = null;
                  });
                },
              ),
              SizedBox(height: 15.0),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) => (val != null) ? null : "Selecciona una subcategoria",
                value: _subcategoty,
                elevation: 10,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.list),
                  labelText: "Subcategoria",
                ),
                items: subcategories[_category ?? "default"]
                    .map((e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _subcategoty = val;
                  });
                },
              ),
              SwitchListTile(
                value: _isCountable,
                title: AutoSizeText(
                  "Producto con cantidades limitadas",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onChanged: (val) {
                  setState(() {
                    _isCountable = val;
                  });
                },
              ),
              if (_isCountable)
                CustomInputText(
                  valueCallback: (val) => _amount = int.tryParse(val),
                  label: "Cantidad",
                  validator: (val) =>
                      (int.tryParse(val ?? "0") > 0) ? null : "Ingresa una cantidad valida",
                  initialValue: 0.toString(),
                  icon: IconData('#'.codeUnitAt(0)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              CustomInputText(
                autovalidateMode: AutovalidateMode.disabled,
                initialValue: (_price ?? 0).toString(),
                valueCallback: (val) => _price = int.tryParse(val ?? "0"),
                label: "Precio",
                validator: (val) =>
                    (int.tryParse(val ?? "0") > 0) ? null : "Ingresa un precio valido",
                icon: Icons.monetization_on_outlined,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SwitchListTile(
                value: _isCustomizable,
                title: AutoSizeText(
                  "Producto personalizable",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onChanged: (val) {
                  setState(() {
                    _isCustomizable = val;
                    if (!val) {
                      _options = Map();
                      _opts = [];
                    }
                  });
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _opts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6.0,
                    margin: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomInputText(
                                  initialValue: "",
                                  valueCallback: (val) => _opts[index] = val,
                                  enabled: _enabledFilds[index],
                                  label: 'Item ${index + 1}',
                                  icon: IconData('${index + 1}'.codeUnitAt(0)),
                                  validator: (val) =>
                                      (val.length > 0) ? null : "Ingresa el nombre del item",
                                ),
                              ),
                              SizedBox(
                                width: 50.0,
                                child: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () => addOption(index),
                                ),
                              )
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: _options[_opts[index]]?.length ?? 0,
                            itemBuilder: (context, item) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 50.0,
                                  ),
                                  Expanded(
                                    child: CustomInputText(
                                      initialValue: "",
                                      valueCallback: (val) => _options[_opts[index]][item] = val,
                                      label: "Opción ${item + 1}",
                                      icon: Icons.label_important,
                                      validator: (val) => (val.length > 0)
                                          ? null
                                          : "Ingresa el nombre de la opción",
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0),
              if (_isCustomizable)
                Center(
                  child: ElevatedButton(
                    onPressed: addItem,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_circle),
                        SizedBox(width: 10.0),
                        Text("Agregar Item"),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: registProduct,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_to_photos_rounded),
                      SizedBox(width: 5.0),
                      Text("Registrar nuevo producto"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool valid = _formKey.currentState.validate();
    if (_images.length < 1) {
      messenger("Agrega por lo menos una foto de tu producto", 2);
      return false;
    }
    return valid;
  }

  void registProduct() async {
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
              Icon(
                Icons.warning_amber_rounded,
                size: 100.0,
                color: Colors.red,
              ),
              Text("Advertencia!"),
            ],
          ),
          content: Text("¿Estas seguro de agregar este producto a tu lista de venta?"),
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
                  useSafeArea: true,
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
                final images = await _productsProvider.saveImages(_images, _name);
                ProductModel product = ProductModel(
                  name: _name,
                  description: _description,
                  category: _category,
                  subcategory: _subcategoty,
                  businessId: _businessId,
                  isCountable: _isCountable,
                  amount: (_isCountable) ? _amount : null,
                  price: _price,
                  isCustomizable: _isCustomizable,
                  options: (_isCustomizable) ? _options : null,
                  images: images,
                );
                bool save = await _productsProvider.saveProduct(product);
                Navigator.of(this.context).pop();
                if (save) {
                  messenger("Datos guardados", 2);
                  Navigator.of(this.context).pop();
                } else
                  messenger("Error al enviar datos", 2);
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

  void addOption(int index) {
    setState(() {
      if (_opts[index] == "") {
        messenger("Ingresa el nombre del item", 2);
        return;
      }
      if (!_options.containsKey(_opts[index])) {
        _options[_opts[index]] = [];
        _enabledFilds[index] = false;
      }
      bool f = true;
      _options[_opts[index]].forEach((element) {
        if (element == "" && f) {
          f = false;
          messenger("Completa todas las opciones creadas", 2);
        }
      });
      if (!f) return;
      _options[_opts[index]].add("");
    });
  }

  void addItem() {
    setState(() {
      bool f = true;
      _opts.forEach((element) {
        if (element == "" && f) {
          f = false;
          messenger("Completa todas los items creados", 2);
        }
      });
      if (!f) return;
      _opts.add("");
      _enabledFilds.add(true);
    });
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
