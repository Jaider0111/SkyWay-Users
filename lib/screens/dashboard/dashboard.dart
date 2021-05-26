import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  String _type;
  String _name;
  AuthProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = BlocProvider.of<AuthProvider>(context);
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    _type = (args.containsKey("user")) ? args["user"] : null;
    if (_type == null) {
      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    }
    _name = (_type == "Usuario") ? _provider.user.name : _provider.shop.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
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
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Binvenido a SkyWay $_name"),
                  if (_type == "Tienda")
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('addProduct', arguments: {
                          "businessId": _provider.shop.id,
                        });
                      },
                      child: Text("Agregar Producto"),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      _provider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                    },
                    child: Text("Cerrar sesión"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
