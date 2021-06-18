import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/consts/themes.dart';
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
            child:
                (constraints.maxWidth > 800.0) ? _rowView(constraints) : _columnView(constraints),
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
        Text("kk"),
        profileView(constraints),
      ],
    );
  }

  Widget profileView(BoxConstraints constraints) {
    return SizedBox(
        height: (constraints.maxWidth > 800.0)
            ? constraints.maxHeight
            : min(constraints.maxWidth, constraints.maxHeight),
        width: (constraints.maxWidth > 800.0) ? constraints.maxWidth / 1.3 : constraints.maxWidth,
        child: Theme(
          data: ThemeData(fontFamily: "Itim", primaryColor: Colors.black),
          child: Scrollbar(
            isAlwaysShown: true,
            radius: Radius.elliptical(30.0, 50.0),
            thickness: 15.0,
            child: Form(
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
                                    left: (constraints.maxWidth <= 800) ? 150.0 : 250.0,
                                    top: (constraints.maxWidth <= 800) ? 100.0 : 150.0),
                                child: Text(
                                  '${_user.name} ${(_type == "Usuario") ? _user.lastname : ""}\n ${_provider.status}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: "Itim",
                                    fontSize: (constraints.maxWidth <= 800) ? 20 : 35,
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
                                  radius: (constraints.maxWidth <= 800) ? 65.0 : 110.0,
                                  backgroundImage: (_type == "Usuario" && _user.image != null)
                                      ? NetworkImage(_user.image)
                                      : AssetImage("assets/images/avatar_profile.png"),
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
                    validator: (val) => (val.length >= 3) ? null : "Ingrese nombre valido",
                  ),
                  if (_type == "Usuario")
                    MyContainer(
                      constraints: constraints,
                      fieldName: "Apellidos:",
                      text: "${_user.lastname} ",
                      edit: _edit,
                      onChange: (val) => _user.lastname = val,
                      validator: (val) => (val.length >= 3) ? null : "Ingrese apellido valido",
                    ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Identificación:",
                    text: "${_user.identification}",
                    edit: _edit,
                    onChange: (val) => _user.identification = val,
                    validator: (val) => (val.length >= 8) ? null : "Ingrese identificación valida",
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Dirección:",
                    text: "${_user.address ?? "-"}",
                    edit: _edit,
                    onChange: (val) => _user.address = val,
                    validator: (val) => null,
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Email:",
                    text: "${_user.email}",
                    edit: _edit,
                    onChange: (val) => _user.identification = val,
                    validator: (val) => (val.contains(RegExp(r'^[\w\.\*-_\+]+@[a-z]+(\.[a-z]+)+$')))
                        ? null
                        : "Ingresa un correo correcto",
                  ),
                  MyContainer(
                    constraints: constraints,
                    fieldName: "Teléfono:",
                    text: "${_user.phone ?? "-"}",
                    edit: _edit,
                    onChange: (val) => _user.phone = val,
                    validator: (val) =>
                        (val.length >= 10) ? null : "Ingrese número de teléfono valido",
                  ),
                  if (_type == "Tienda")
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      width: (constraints.maxWidth > 800.0)
                          ? constraints.maxWidth / 4
                          : constraints.maxWidth,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ShopSchedule(
                        enable: _edit,
                        data: _user.schedule.cast<String>(),
                        constraints: constraints,
                        onChange: (val) {
                          _user.schedule = val;
                        },
                      ),
                    ),
                  if (_type == "Tienda")
                    MyContainer(
                      constraints: constraints,
                      fieldName: "Categoría:",
                      text: "${_user.category}",
                      edit: _edit,
                      onChange: (val) => _user.category = val,
                      validator: (val) => (val.length >= 10) ? null : "Ingrese categoría valida",
                    )
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
      width: (constraints.maxWidth > 800.0) ? constraints.maxWidth / 4 : constraints.maxWidth,
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
                    topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: Colors.black,
                )),
            child: Text(
              fieldName,
              textAlign: TextAlign.start,
              style: TextStyle(
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
