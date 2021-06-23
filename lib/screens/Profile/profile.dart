import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/models/collections/categories.dart';
import 'package:skyway_users/models/widgets/custom_input_form.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/Registro/shop_schedule.dart';
import 'package:skyway_users/screens/navigation_bar.dart';
import 'dart:math';
import '../appbar.dart';
import '../unauthorizedPage.dart';

main(List<String> args) {
  runApp(MaterialApp(
    home: ProfilePage(),
    theme: defaultTheme,
  ));
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _type;
  AuthProvider _provider;
  dynamic _user;
  bool _edit;
  bool _changePassword;
  String _password;
  String _cPassword;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _changePassword = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    if (args.containsKey("edit"))
      _edit = args["edit"];
    else
      _edit = false;
    _provider = BlocProvider.of<AuthProvider>(context);
    _type = "Tienda";
    _type = _provider.status;

    if (_type != "Usuario" && _type != "Tienda") {
      return UnauthorizedPage(info: "Por favor inicia sesión en la aplicación");
    }
    _user = (_type == "Usuario") ? _provider.user : _provider.shop;
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child: (constraints.maxWidth > 800.0)
                ? _rowView(constraints)
                : _columnView(constraints),
          );
        },
      ),
    );
  }

  Widget _rowView(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.all(20),
      width: constraints.maxWidth - 30.0,
      height: constraints.maxHeight - 30.0,
      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          sideBar(constraints),
          profileView(constraints),
        ],
      ),
    );
  }

  Widget _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        profileView(constraints),
      ],
    );
  }

  Widget profileView(BoxConstraints constraints) {
    return SizedBox(
        height: (constraints.maxWidth > 800.0)
            ? constraints.maxHeight
            : min(constraints.maxWidth, constraints.maxHeight),
        width: (constraints.maxWidth > 800.0)
            ? constraints.maxWidth / 1.3
            : constraints.maxWidth,
        child: Theme(
          data: ThemeData(fontFamily: "Itim", primaryColor: Colors.black),
          child: Scrollbar(
            isAlwaysShown: true,
            radius: Radius.elliptical(30.0, 50.0),
            thickness: 15.0,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 20, left: 20, top: 20),
                        height: constraints.maxHeight / 2.0,
                        width: (constraints.maxWidth > 800.0)
                            ? constraints.maxWidth / 1.3
                            : constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          image: DecorationImage(
                            image: ExactAssetImage('images/cover_page.jpg'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    left: (constraints.maxWidth <= 800)
                                        ? 150.0
                                        : 250.0,
                                    top: (constraints.maxWidth <= 800)
                                        ? 100.0
                                        : 150.0),
                                child: Text(
                                  '${_user.name} ${(_type == "Usuario") ? _user.lastname : ""}\n ${_provider.status}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Itim",
                                    fontSize:
                                        (constraints.maxWidth <= 800) ? 20 : 35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 40.0, top: 150.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: (constraints.maxWidth <= 800)
                                      ? 65.0
                                      : 110.0,
                                  backgroundImage: (_type == "Usuario" &&
                                          _user.image != null)
                                      ? NetworkImage(_user.image)
                                      : AssetImage(
                                          "assets/images/avatar_profile.png"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [Container()],
                      )
                      //your elements here
                    ],
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Nombres:",
                    text: "${_user.name}",
                    edit: _edit,
                    onChange: (val) => _user.name = val,
                    validator: (val) =>
                        (val.length >= 3) ? null : "Ingrese nombre valido",
                  ),
                  if (_type == "Usuario")
                    MyContainer(
                      constraints: constraints,
                      fieldName: "Apellidos:",
                      text: "${_user.lastname} ",
                      edit: _edit,
                      onChange: (val) => _user.lastname = val,
                      validator: (val) =>
                          (val.length >= 3) ? null : "Ingrese apellido valido",
                    ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Identificación:",
                    text: "${_user.identification}",
                    edit: _edit,
                    onChange: (val) => _user.identification = val,
                    validator: (val) => (val.length >= 8)
                        ? null
                        : "Ingrese identificación valida",
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Dirección:",
                    text: "${_user.address ?? "-"}",
                    edit: _edit,
                    onChange: (val) => _user.address = val,
                    validator: (val) => (val.length > 5)
                        ? null
                        : "Ingresa una dirección válida",
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Email:",
                    text: "${_user.email}",
                    edit: _edit,
                    onChange: (val) => _user.email = val,
                    validator: (val) => (val.contains(
                            RegExp(r'^[\w\.\*-_\+]+@[a-z]+(\.[a-z]+)+$')))
                        ? null
                        : "Ingresa un correo correcto",
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Teléfono:",
                    text: "${_user.phone ?? "-"}",
                    edit: _edit,
                    onChange: (val) => _user.phone = val,
                    validator: (val) => (val.length >= 10)
                        ? null
                        : "Ingrese número de teléfono valido",
                  ),
                  if (_type == "Tienda")
                    myContainer_V2(
                      constraints: constraints,
                      child: ShopSchedule(
                        enable: _edit,
                        data: _user.schedule.cast<String>(),
                        constraints: constraints,
                        onChange: (val) {
                          _user.schedule = val;
                        },
                      ),
                    ),
                  if (_type == "Tienda" && _edit)
                    myContainer_V2(
                      constraints: constraints,
                      child: DropdownButtonFormField<String>(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) =>
                            (val != null) ? null : "Selecciona una categoria",
                        value: _user.category,
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
                            _user.category = val;
                          });
                        },
                      ),
                    ),
                  if (_type == "Tienda" && !_edit)
                    MyContainer(
                      constraints: constraints,
                      fieldName: "Categoría:",
                      text: "${_user.category}",
                      edit: _edit,
                      onChange: (val) => _user.category = val,
                      validator: null,
                    ),
                  //Contraseña
                  if (_edit)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      width: 300.0,
                      child: SwitchListTile(
                        value: _changePassword,
                        onChanged: (val) {
                          setState(() {
                            _changePassword = val;
                          });
                        },
                        title: Text("¿Deseas cambiar tu contraseña?"),
                      ),
                    ),
                  if (_changePassword) ...[
                    myContainer_V2(
                      child: CustomInputText(
                          autovalidateMode: AutovalidateMode.always,
                          initialValue: "",
                          valueCallback: (val) => _password = val,
                          label: "Ingresa tu contraseña",
                          icon: Icons.lock,
                          showText: false,
                          validator: (val) => (val.length >= 8)
                              ? null
                              : "La contraseña debe contener minimo 8 caracteres"),
                      constraints: constraints,
                    ),
                    myContainer_V2(
                      child: CustomInputText(
                          autovalidateMode: AutovalidateMode.always,
                          initialValue: "",
                          valueCallback: (val) => _user.password = val,
                          label: "Confirma tu contraseña",
                          icon: Icons.lock,
                          showText: false,
                          validator: (val) => (val == _password)
                              ? null
                              : "Las contraseñas no coinciden"),
                      constraints: constraints,
                    ),
                  ],
                  if (_edit)
                    Center(
                      child: ElevatedButton(
                        onPressed: updateProfile,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.update),
                            SizedBox(width: 5.0),
                            Text("Actualiza tu perfil"),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget sideBar(BoxConstraints constraints) {
    return NavBar(
      width: constraints.maxWidth / 6.0,
      height: constraints.maxHeight,
    );
  }

  Future<void> updateProfile() async {
    bool valid = _formKey.currentState.validate();
    if (!valid) return;
    await showDialog(
      context: this.context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              Text("Estás a un paso"),
            ],
          ),
          content: Text("Pulsa continuar para actualizar tu perfil"),
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
                /* final image = (_perfil.length > 0)
                    ? await BlocProvider.of<AuthProvider>(this.context)
                        .saveImage(_perfil[0], (_type) ? "$_name" : "$_name$_lastname")
                    : null;
                    */
                String save = (_type == "Tienda")
                    ? await BlocProvider.of<AuthProvider>(this.context)
                        .updateStore(_user)
                    : await BlocProvider.of<AuthProvider>(this.context)
                        .updatePersona(_user);

                Navigator.of(this.context).pop();
                if (save == "Actualización exitosa") {
                  messenger(save, 3, this.context);
                  Navigator.of(this.context).popAndPushNamed('profile');
                } else if (save == "Actualización erronea")
                  messenger(save, 3, this.context);
                else
                  messenger("Error al enviar datos", 2, this.context);
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
}

class MyContainer extends StatelessWidget {
  const MyContainer({
    Key key,
    @required this.constraints,
    @required this.fieldName,
    @required this.text,
    @required this.edit,
    @required this.onChange,
    @required this.validator,
  }) : super(key: key);

  final BoxConstraints constraints;
  final String fieldName;
  final String text;
  final bool edit;
  final void Function(String) onChange;
  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: text);
    return Container(
      margin: EdgeInsets.all(20),
      width: (constraints.maxWidth > 800.0)
          ? constraints.maxWidth / 4
          : constraints.maxWidth,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              color: Colors.white60,
            ),
            child: Text(
              fieldName,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.deepPurple,
                fontFamily: "Itim",
                fontSize: (constraints.maxWidth <= 800) ? 20.0 : 30.0,
              ),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: TextFormField(
              onChanged: onChange,
              validator: validator,
              controller: controller,
              enabled: edit,
              decoration: InputDecoration(
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
              style: TextStyle(
                fontFamily: "Itim",
                fontSize: (constraints.maxWidth <= 800) ? 20.0 : 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class myContainer_V2 extends StatelessWidget {
  const myContainer_V2(
      {Key key, @required this.child, @required this.constraints})
      : super(key: key);
  final Widget child;
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      width: (constraints.maxWidth > 800.0)
          ? constraints.maxWidth / 4
          : constraints.maxWidth,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    );
  }
}
