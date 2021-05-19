import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/models/collections/Tienda.dart';
import 'package:skyway_users/models/collections/categories.dart';
import 'package:skyway_users/models/collections/persona.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/registro_Provider.dart';
import 'package:skyway_users/screens/Registro/perfil_view.dart';
import 'package:skyway_users/screens/new_product/images_view.dart';

class RegistroPage extends StatefulWidget {
  RegistroPage({Key key}) : super(key: key);

  @override
  RegistroState createState() => RegistroState();
}

class RegistroState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  List<Uint8List> _perfil = [];
  String _Nombre;
  String _Apellidos;
  String _Doc;
  String _Correo;
  String _Tel;
  String _dir;
  String _Password;
  String _CPassword;
  bool _Vendedor;
  String _NombreTienda;
  String _NIT;
  String _Passwordt;
  String _CPasswordt;
  List _hora;
  String _correot;
  String _telt;
  String _direcciont;
  String _Categoria;
  List<String> _opts = [];
  Map<String, List<String>> _options = Map();

  @override
  void initState() {
    _Vendedor = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'SkyWay',
            style: TextStyle(fontSize: 30, fontFamily: "Pacifica"),
          ),
        ),
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
        ));
  }

  Widget _rowView(BoxConstraints constraints) {
    return Row(children: [
      productForm(constraints),
    ]);
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        productForm(constraints),
      ],
    );
  }

  Widget _ft(BoxConstraints constraints) {
    return ListView(
      children: [
        tiendaForm(constraints),
      ],
    );
  }

  Widget tiendaForm(BoxConstraints constraints) {
    return SizedBox(
        height: (constraints.maxWidth > 800.0)
            ? constraints.maxHeight
            : min(constraints.maxWidth, constraints.maxHeight),
        width: (constraints.maxWidth > 800.0)
            ? constraints.maxWidth / 2.0
            : constraints.maxWidth,
        child: Form(
            key: _formKey,
            child: ListView(padding: EdgeInsets.all(20.0), children: [
              AutoSizeText(
                'Registra tu tienda',
                style: TextStyle(fontSize: 35.0),
                minFontSize: 0.0,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _NombreTienda = val,
                label: "Como se llama tu tienda?",
                icon: Icons.shopping_cart,
              ),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _NIT,
                  label: "Ingresa tu NIT",
                  icon: Icons.shop),
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) =>
                    (val != null) ? null : "Selecciona una categoria",
                value: _Categoria,
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
                    _Categoria = val;
                  });
                },
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _Correo = val,
                label: "Ingresa tu correo",
                icon: Icons.mail,
                validator: (val) =>
                    (val.length > 0) ? null : "Debes llenar este campo",
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _Tel = val,
                label: "Ingresa tu numero telefonico",
                icon: Icons.phone,
                keyboardType: TextInputType.number,
              ),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _dir,
                  label: "Ingresa tu direccion",
                  icon: Icons.location_city),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _Password = val,
                label: "Ingresa tu contraseña",
                icon: Icons.lock,
                showText: false,
              ),
              CustomInputText(
                initialValue: "",
                valueCallback: (val) => _CPassword = val,
                label: "Confirma tu contraseña",
                icon: Icons.lock,
                showText: false,
              ),
            ])));
  }

  Widget productForm(BoxConstraints constraints) {
    return SizedBox(
        height: (constraints.maxWidth > 800.0)
            ? constraints.maxHeight
            : min(constraints.maxWidth, constraints.maxHeight),
        width: (constraints.maxWidth > 800.0)
            ? constraints.maxWidth / 2.0
            : constraints.maxWidth,
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: [
                AutoSizeText(
                  'Registrate',
                  style: TextStyle(fontSize: 35.0),
                  minFontSize: 0.0,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                PerfilView(
                  updateImages: (imgs) => _perfil = imgs,
                  isWeb: kIsWeb,
                  constraints: constraints,
                ),
                SizedBox(height: 40.0),
                CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _Nombre = val,
                  label: 'Ingresa tu nombre',
                  icon: Icons.badge,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo",
                ),
                CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _Apellidos = val,
                  label: 'Ingresa tus apellidos',
                  icon: Icons.badge,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo",
                ),
                CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _Correo = val,
                  label: "Ingresa tu documento",
                  icon: Icons.perm_identity,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo",
                ),
                CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _Correo = val,
                  label: "Ingresa tu correo",
                  icon: Icons.mail,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo",
                ),
                CustomInputText(
                    initialValue: "",
                    valueCallback: (val) => _Tel = val,
                    label: "Ingresa tu numero telefonico",
                    icon: Icons.phone,
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        (val.length > 0) ? null : "Debes llenar este campo"),
                CustomInputText(
                    initialValue: "",
                    valueCallback: (val) => _dir,
                    label: "Ingresa tu direccion",
                    icon: Icons.location_city,
                    validator: (val) =>
                        (val.length > 0) ? null : "Debes llenar este campo"),
                CustomInputText(
                    initialValue: "",
                    valueCallback: (val) => _Password = val,
                    label: "Ingresa tu contraseña",
                    icon: Icons.lock,
                    showText: false,
                    validator: (val) =>
                        (val.length > 0) ? null : "Debes llenar este campo"),
                CustomInputText(
                    initialValue: "",
                    valueCallback: (val) => _CPassword = val,
                    label: "Confirma tu contraseña",
                    icon: Icons.lock,
                    showText: false,
                    validator: (val) =>
                        (val.length > 0) ? null : "Debes llenar este campo"),
                SwitchListTile(
                    value: _Vendedor,
                    title: AutoSizeText("Soy vendedor",
                        style: Theme.of(context).textTheme.bodyText1),
                    onChanged: (val) {
                      setState(() {
                        _Vendedor = val;
                      });
                    }),
                if (_Vendedor)
                  AutoSizeText(
                    'Registra tu tienda',
                    style: TextStyle(fontSize: 35.0),
                    minFontSize: 0.0,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _NombreTienda = val,
                      label: "Como se llama tu tienda?",
                      icon: Icons.shopping_cart,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _NIT = val,
                      label: "Ingresa tu NIT",
                      icon: Icons.shop,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                if (_Vendedor)
                  DropdownButtonFormField<String>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) =>
                        (val != null) ? null : "Selecciona una categoria",
                    value: _Categoria,
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
                        _Categoria = val;
                      });
                    },
                  ),
                if (_Vendedor)
                  CustomInputText(
                    initialValue: "",
                    valueCallback: (val) => _correot = val,
                    label: "Ingresa tu correo",
                    icon: Icons.mail,
                    validator: (val) =>
                        (val.length > 0) ? null : "Debes llenar este campo",
                  ),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _telt = val,
                      label: "Ingresa tu numero telefonico",
                      icon: Icons.phone,
                      keyboardType: TextInputType.number,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _direcciont = val,
                      label: "Ingresa tu direccion",
                      icon: Icons.location_city,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _Passwordt = val,
                      label: "Ingresa tu contraseña",
                      icon: Icons.lock,
                      showText: false,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                if (_Vendedor)
                  CustomInputText(
                      initialValue: "",
                      valueCallback: (val) => _CPasswordt = val,
                      label: "Confirma tu contraseña",
                      icon: Icons.lock,
                      showText: false,
                      validator: (val) =>
                          (val.length > 0) ? null : "Debes llenar este campo"),
                Center(
                  child: ElevatedButton(
                    onPressed: regist,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_to_photos_rounded),
                        SizedBox(width: 5.0),
                        Text("Registate"),
                      ],
                    ),
                  ),
                ),
              ],
            )));
  }

  void regist() async {
    bool valid = validate();
    bool valid2 = validatet();
    _opts.forEach((element) {
      if (!_options.containsKey(element)) _options[element] = [];
    });
    if (!valid) return;
    if (_Vendedor) {
      if (!valid2) return;
    }
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Estas a un paso"),
            ],
          ),
          content: Text("Pulsa continuar para registrate"),
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
                /* final images = await BlocProvider.of<registro_Provider>(this.context)
                    .saveImages(_images, _name);*/
                TiendaModel tienda;
                bool saves = true;
                PersonaModel persona = PersonaModel(
                    Nombre: _Nombre,
                    Apellidos: _Apellidos,
                    Doc: _Doc,
                    Correo: _Correo,
                    Tel: _Tel,
                    Password: _Password,
                    dir: _dir);
                if (_Vendedor) {
                  tienda = TiendaModel(
                      telt: _telt,
                      NIT: _NIT,
                      Passwordt: _Passwordt,
                      hora: ["8:00-12:00", "12:00-15:00"],
                      NombreTienda: _NombreTienda,
                      direcciont: _direcciont,
                      Categoria: _Categoria,
                      correot: _correot);
                }
                bool savep =
                    await BlocProvider.of<RegistroProvider>(this.context)
                        .savePersona(persona);
                if (_Vendedor) {
                  saves = await BlocProvider.of<RegistroProvider>(this.context)
                      .saveStore(tienda);
                }
                Navigator.of(this.context).pop();
                if (savep && saves)
                  /*Navigator.of(this.context).pushNamedAndRemoveUntil(
                    'dashboard',
                    (_) => true,
                    arguments: {'image': product.images[0]},
                  );*/
                  messenger("Datos guardados", 2);
                else
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

  bool validate() {
    bool valid = _formKey.currentState.validate();
    if (_Password != _CPassword) {
      messenger("Las constraseñas para el usuario no coinciden", 3);
      return false;
    }
    return valid;
  }

  bool validatet() {
    bool valid = _formKey.currentState.validate();
    if (_Passwordt != _CPasswordt) {
      messenger("Las constraseñas para la tienda no coinciden", 3);
      return false;
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
