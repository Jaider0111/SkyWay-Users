import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/models/collections/store.dart';
import 'package:skyway_users/models/collections/categories.dart';
import 'package:skyway_users/models/collections/user.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/Registro/shop_schedule.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/images_view.dart';

class RegistroPage extends StatefulWidget {
  RegistroPage({Key key}) : super(key: key);

  @override
  RegistroState createState() => RegistroState();
}

class RegistroState extends State<RegistroPage> {
  final _formKey = GlobalKey<FormState>();
  List<Uint8List> _perfil = [];
  String _name;
  String _lastname;
  String _identification;
  String _email;
  String _phone;
  String _address;
  String _password;
  String _cPassword;
  List _hora;
  String _category;
  bool _type;
  final TextStyle errorStyle = TextStyle(color: Colors.red);

  @override
  void initState() {
    _type = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return BackgroundWidget(
              constraints: constraints,
              child: Row(
                children: [
                  registerType(constraints),
                  if (constraints.maxWidth > 800.0)
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth / 2,
                      child: Image.asset(
                        "assets/images/login_background.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                ],
              ),
            );
          },
        ));
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
          registForm(constraints),
        ],
      ),
    );
  }

  Widget registForm(BoxConstraints constraints) {
    return SizedBox(
      height: constraints.maxHeight - 240.0,
      width: ((constraints.maxWidth > 800.0)
              ? constraints.maxWidth / 2.0
              : constraints.maxWidth) -
          100.0,
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(30.0),
          children: [
            AutoSizeText(
              (_type) ? 'Registra tu tienda' : 'Regístrate',
              style: TextStyle(fontSize: 35.0),
              minFontSize: 0.0,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
            ImagesView(
              title: (_type)
                  ? "Agrega una foto de tu tienda"
                  : "Agrega una foto de perfil",
              isWeb: kIsWeb,
              updateImages: (imgs) => _perfil = imgs,
              height: ((constraints.maxWidth > 800.0)
                      ? constraints.maxHeight
                      : min(constraints.maxWidth, constraints.maxHeight)) /
                  2.0,
              width: ((constraints.maxWidth > 800.0)
                      ? constraints.maxWidth / 4.0
                      : constraints.maxWidth) /
                  2.0,
              multiImage: false,
            ),
            SizedBox(height: 40.0),
            CustomInputText(
              errorStyle: errorStyle,
              initialValue: "",
              valueCallback: (val) => _name = val,
              label:
                  (_type) ? "¿Cómo se llama tu tienda?" : 'Ingresa tu nombre',
              icon: (_type) ? Icons.shopping_cart : Icons.badge,
              validator: (val) =>
                  (val.length > 0) ? null : "Debes llenar este campo",
            ),
            if (!_type)
              CustomInputText(
                errorStyle: errorStyle,
                initialValue: "",
                valueCallback: (val) => _lastname = val,
                label: 'Ingresa tus apellidos',
                icon: Icons.badge,
                validator: (val) =>
                    (val.length > 0) ? null : "Debes llenar este campo",
              ),
            CustomInputText(
              errorStyle: errorStyle,
              initialValue: "0",
              autovalidateMode: AutovalidateMode.disabled,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              valueCallback: (val) => _identification = val,
              label: (_type) ? "Ingresa tu NIT" : "Ingresa tu documento",
              icon: (_type) ? Icons.perm_identity : Icons.shop,
              validator: (val) => (int.tryParse(val) > 0)
                  ? null
                  : "Este campo debe ser diferente de 0",
            ),
            if (_type)
              DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) =>
                    (val != null) ? null : "Selecciona una categoria",
                value: _category,
                style: Theme.of(context).textTheme.bodyText1,
                elevation: 10,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.category),
                  labelText: "Categoría",
                  errorStyle: errorStyle,
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
                  });
                },
              ),
            if (_type) ...[
              SizedBox(
                height: 20.0,
              ),
              ShopSchedule(
                constraints: constraints,
                onChange: (val) {
                  _hora = val;
                },
              ),
            ],
            CustomInputText(
              errorStyle: errorStyle,
              initialValue: "",
              valueCallback: (val) => _email = val,
              label: "Ingresa tu correo",
              icon: Icons.mail,
              validator: (val) =>
                  (val.contains(RegExp(r'^[\w\.\*-_\+]+@[a-z]+(\.[a-z]+)+$')))
                      ? null
                      : "Ingresa un correo válido",
            ),
            CustomInputText(
              errorStyle: errorStyle,
              initialValue: "0",
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.disabled,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              valueCallback: (val) {
                _phone = val;
                print(_perfil != null);
                print(_phone);
                print(_email);
              },
              label: "Ingresa tu número telefónico",
              icon: Icons.phone,
              validator: (val) => (int.tryParse(val) > 0)
                  ? null
                  : "Este campo debe ser diferente de 0",
            ),
            CustomInputText(
                errorStyle: errorStyle,
                initialValue: "",
                valueCallback: (val) => _address = val,
                label: "Ingresa tu dirección",
                icon: Icons.location_city,
                validator: (val) =>
                    (val.length > 0) ? null : "Debes llenar este campo"),
            CustomInputText(
                errorStyle: errorStyle,
                autovalidateMode: AutovalidateMode.always,
                initialValue: "",
                valueCallback: (val) => _password = val,
                label: "Ingresa tu contraseña",
                icon: Icons.lock,
                showText: false,
                validator: (val) => (val.length >= 8)
                    ? null
                    : "La contraseña debe contener mínimo 8 caracteres"),
            CustomInputText(
                errorStyle: errorStyle,
                autovalidateMode: AutovalidateMode.always,
                initialValue: "",
                valueCallback: (val) => _cPassword = val,
                label: "Confirma tu contraseña",
                icon: Icons.lock,
                showText: false,
                validator: (val) =>
                    (val == _password) ? null : "Las contraseñas no coinciden"),
            Center(
              child: ElevatedButton(
                onPressed: regist,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_to_photos_rounded),
                    SizedBox(width: 5.0),
                    Text((_type) ? "Regista tu tienda" : "Regístrate"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void regist() async {
    bool valid = validate();
    if (!valid) return;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Estás a un paso"),
            ],
          ),
          content: Text("Pulsa continuar para regístrarte"),
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
                final image = (_perfil.length > 0)
                    ? await BlocProvider.of<AuthProvider>(this.context)
                        .saveImage(
                            _perfil[0], (_type) ? "$_name" : "$_name$_lastname")
                    : null;
                dynamic user;
                if (_type) {
                  user = StoreModel(
                    phone: _phone,
                    identification: _identification,
                    password: _password,
                    schedule: _hora,
                    name: _name,
                    address: _address,
                    category: _category,
                    email: _email,
                    image: image,
                  );
                } else {
                  user = UserModel(
                    name: _name,
                    lastname: _lastname,
                    identification: _identification,
                    email: _email,
                    phone: _phone,
                    password: _password,
                    address: _address,
                    image: image,
                  );
                }

                String save = (_type)
                    ? await BlocProvider.of<AuthProvider>(this.context)
                        .saveStore(user)
                    : await BlocProvider.of<AuthProvider>(this.context)
                        .savePersona(user);

                Navigator.of(this.context).pop();
                if (save == "La identificación ya se encuentra registrada")
                  messenger("La identificación ya se encuentra registrada", 3);
                else if (save == "El correo ya se encuentra registrado")
                  messenger("El correo ya se encuentra registrado", 3);
                else if (save != null) {
                  messenger("Datos guardados", 2);
                  Navigator.of(this.context)
                      .pushNamedAndRemoveUntil('login', (_) => false);
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

  bool validate() {
    bool valid = _formKey.currentState.validate();
    if (_password != _cPassword) {
      messenger("Las constraseñas no coinciden", 3);
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
