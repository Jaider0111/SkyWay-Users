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
import 'package:skyway_users/models/collections/user.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/Registro/perfil_view.dart';
import 'package:skyway_users/screens/new_product/images_view.dart';

class RegistroPage extends StatefulWidget {
  RegistroPage({Key key}) : super(key: key);

  @override
  RegistroState createState() => RegistroState();
}

class RegistroState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
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
  bool _type;
  List<String> _opts = [];
  Map<String, List<String>> _options = Map();

  @override
  void initState() {
    _Vendedor = false;
    _type = false;
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
      registerType(constraints),
      SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth / 2,
        child: Image.asset(
          "assets/images/login_background.png",
          fit: BoxFit.contain,
        ),
      )
    ]);
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        productForm(constraints),
      ],
    );
  }

  Widget tiendaForm(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
            100.0,
        child: Form(
            key: _formKey2,
            child: ListView(padding: EdgeInsets.all(30.0), children: [
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
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo"),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _NIT = val,
                  label: "Ingresa tu NIT",
                  icon: Icons.shop,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo"),
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
                valueCallback: (val) => _correot = val,
                label: "Ingresa tu correo",
                icon: Icons.mail,
                validator: (val) =>
                    (val.length > 0) ? null : "Debes llenar este campo",
              ),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _telt = val,
                  label: "Ingresa tu numero telefonico",
                  icon: Icons.phone,
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo"),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _direcciont = val,
                  label: "Ingresa tu direccion",
                  icon: Icons.location_city,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo"),
              CustomInputText(
                  initialValue: "",
                  valueCallback: (val) => _Passwordt = val,
                  label: "Ingresa tu contraseña",
                  icon: Icons.lock,
                  showText: false,
                  validator: (val) =>
                      (val.length > 0) ? null : "Debes llenar este campo"),
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
                  onPressed: registt,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_to_photos_rounded),
                      SizedBox(width: 5.0),
                      Text("Regista tu tienda"),
                    ],
                  ),
                ),
              ),
            ])));
  }

  Widget registerType(BoxConstraints constraints) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Bienvenido a SkyWay",
            style: TextStyle(fontSize: 40.0),
          ),
          SizedBox(
            height: 15.0,
          ),
          SizedBox(
            width: 300.0,
            child: SwitchListTile(
              value: _type,
              onChanged: (val) {
                setState(() {
                  _type = val;
                });
              },
              title: Text("¿Eres vendedor?"),
            ),
          ),
          (_type) ? tiendaForm(constraints) : productForm(constraints),
        ],
      ),
    );
  }

  Widget productForm(BoxConstraints constraints) {
    return SizedBox(
        height: constraints.maxHeight - 240.0,
        width: ((constraints.maxWidth > 800.0)
                ? constraints.maxWidth / 2.0
                : constraints.maxWidth) -
            100.0,
        child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(30.0),
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
                  valueCallback: (val) => _Doc = val,
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

                UserModel persona = UserModel(
                    name: _Nombre,
                    lastname: _Apellidos,
                    identification: _Doc,
                    email: _Correo,
                    phone: int.tryParse(_Tel),
                    password: _Password,
                    address: _dir);

                String savep = await BlocProvider.of<AuthProvider>(this.context)
                    .savePersona(persona);

                Navigator.of(this.context).pop();
                if (savep == "La identificacion ya se encuentra registrado")
                  /*Navigator.of(this.context).pushNamedAndRemoveUntil(
                    'dashboard',
                    (_) => true,
                    arguments: {'image': product.images[0]},
                  );*/
                  messenger("La identificación ya se encuentra registrada", 3);
                else if (savep == "El correo ya se encuentra registrado")
                  messenger("El correo ya se encuentra registrado", 3);
                else if (savep != null)
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

  void registt() async {
    bool valid2 = validatet();
    _opts.forEach((element) {
      if (!_options.containsKey(element)) _options[element] = [];
    });

    if (!valid2) return;

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

                TiendaModel tienda = TiendaModel(
                    telt: _telt,
                    NIT: _NIT,
                    Passwordt: _Passwordt,
                    hora: ["8:00-12:00", "12:00-15:00"],
                    NombreTienda: _NombreTienda,
                    direcciont: _direcciont,
                    Categoria: _Categoria,
                    correot: _correot);

                String saves = await BlocProvider.of<AuthProvider>(this.context)
                    .saveStore(tienda);

                Navigator.of(this.context).pop();
                if (saves == "La identificacion ya se encuentra registrado")
                  /*Navigator.of(this.context).pushNamedAndRemoveUntil(
                    'dashboard',
                    (_) => true,
                    arguments: {'image': product.images[0]},
                  );*/
                  messenger("La identificacion ya se encuentra registrada", 3);
                else if (saves == "El correo ya se encuentra registrado")
                  messenger("El correo ya se encuentra registrado", 3);
                else if (saves != null)
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
    bool valid = _formKey2.currentState.validate();
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
