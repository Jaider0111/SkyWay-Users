import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/providers/auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
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
        builder: (context, constraints) {
          return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepOrange,
                    Colors.deepPurple,
                  ],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraint) {
                  return (constraints.maxWidth > 800.0)
                      ? _rowView(constraints)
                      : _columnView(constraints);
                },
              ));
        },
      ),
    );
  }

  _rowView(BoxConstraints constraints) {
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
          side_bar(constraints),
          profile_view(constraints),
        ],
      ),
    );
  }

  _columnView(BoxConstraints constraints) {
    return ListView(
      children: [
        Text("kk"),
        profile_view(constraints),
      ],
    );
  }

  Widget profile_view(BoxConstraints constraints) {
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
                                backgroundImage:
                                    (_type == "Usuario" && _user.image != null)
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
                my_container(constraints, "Nombres: ${_user.name}"),
                if (_type == "Usuario")
                  my_container(constraints, "Apellidos:${_user.lastname} "),
                my_container(
                    constraints, "Identificación: ${_user.identification}"),
                my_container(constraints, "Dirección: ${_user.address}"),
                my_container(constraints, "Email: ${_user.email}"),
                my_container(constraints, "Teléfono: ${_user.phone}"),
                if (_type == "Tienda")
                  my_container(constraints, "Horario: ${_user.schedule}"),
                if (_type == "Tienda")
                  my_container(constraints, "Categoría: ${_user.category}")
              ],
            ),
          ),
        ));
  }

  Widget my_container(BoxConstraints constraints, String text) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 20.0),
      margin: EdgeInsets.only(bottom: 20, left: 20, top: 20),
      height: constraints.maxHeight / 7,
      width: (constraints.maxWidth > 800.0)
          ? constraints.maxWidth / 4
          : constraints.maxWidth,
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontFamily: "Itim",
          fontSize: (constraints.maxWidth <= 800) ? 20.0 : 30.0,
        ),
      ),
    );
  }

  Widget side_bar(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            margin: EdgeInsets.all(20),
            height: constraints.maxHeight - 80.0,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Align(
              alignment: Alignment.topRight,
            ))
      ],
    );
  }
}
