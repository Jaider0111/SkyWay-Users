import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/screens/new_product/images_view.dart';

class AddProductPage extends StatefulWidget {
  AddProductPage({Key key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _description;
  bool _isCountable;
  int _amount;
  int _price;
  bool _isCustomizable;
  List<String> _options = [];
  List<bool> _enabledFilds = [];
  List<String> _images = [];
  Map<String, List<String>> _subproducts = Map();

  @override
  void initState() {
    _isCountable = false;
    _isCustomizable = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.deepOrange,
          Colors.deepPurple,
        ],
        begin: Alignment.topRight,
        end: Alignment.topLeft,
      )),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return (constraints.maxWidth > 800)
              ? _rowView(constraints)
              : _columnView(constraints);
        },
      ),
    );
  }

  Widget productForm(BoxConstraints constraints) {
    return SizedBox(
      height: (constraints.maxWidth > 800)
          ? constraints.maxHeight
          : min(constraints.maxWidth, constraints.maxHeight),
      width: (constraints.maxWidth > 800)
          ? constraints.maxWidth / 2
          : constraints.maxWidth,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            AutoSizeText(
              'Registra tu nuevo producto',
              style: TextStyle(fontSize: 35),
              minFontSize: 0,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            CustomInputText(
              valueCallback: (val) => _name = val,
              label: "Nombre del Producto",
              icon: Icons.food_bank_rounded,
            ),
            CustomInputText(
              valueCallback: (val) => _description = val,
              label: "Describe tu producto",
              icon: Icons.description_rounded,
              maxLines: 5,
            ),
            SwitchListTile(
              value: _isCountable,
              title: AutoSizeText("Producto con cantidades limitadas"),
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
                initialValue: (_amount ?? 0).toString(),
                icon: IconData('#'.codeUnitAt(0)),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            CustomInputText(
              initialValue: (_price ?? 0).toString(),
              valueCallback: (val) => _price = int.tryParse(val),
              label: "Precio",
              icon: Icons.monetization_on_outlined,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SwitchListTile(
              value: _isCustomizable,
              title: AutoSizeText("Producto personalizable"),
              onChanged: (val) {
                setState(() {
                  _isCustomizable = val;
                  if (!val) {
                    _subproducts = Map();
                    _options = [];
                  }
                });
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _options.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 6,
                  margin: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputText(
                                valueCallback: (val) {
                                  _options[index] = val;
                                },
                                enabled: _enabledFilds[index],
                                label: 'Item ${index + 1}',
                                icon: IconData('${index + 1}'.codeUnitAt(0)),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    if (_options[index] == "") {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text("Ingresa el nombre del item"),
                                        duration: Duration(seconds: 2),
                                      ));
                                      return;
                                    }
                                    if (!_subproducts
                                        .containsKey(_options[index])) {
                                      _subproducts[_options[index]] = [];
                                      _enabledFilds[index] = false;
                                    }
                                    _subproducts[_options[index]].add("");
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _subproducts[_options[index]]?.length ?? 0,
                          itemBuilder: (context, item) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                Expanded(
                                  child: CustomInputText(
                                    valueCallback: (val) =>
                                        _subproducts[_options[index]][item] =
                                            val,
                                    label: "Opción ${item + 1}",
                                    icon: Icons.label_important,
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
            if (_isCustomizable)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _options.add("");
                      _enabledFilds.add(true);
                    });
                  },
                  child: Text("Agregar Item"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    elevation: 6,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _rowView(BoxConstraints constraints) {
    return Row(
      children: [
        ImagesView(
          updateImages: (imgs) => _images = imgs,
          isWeb: kIsWeb,
          constraints: constraints,
        ),
        productForm(constraints)
      ],
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        ImagesView(
          updateImages: (imgs) => _images = imgs,
          isWeb: kIsWeb,
          constraints: constraints,
        ),
        productForm(constraints)
      ],
    );
  }
}
