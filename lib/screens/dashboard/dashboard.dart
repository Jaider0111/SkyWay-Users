import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/providers/auth_provider.dart';
import 'package:skyway_users/screens/appbar.dart';
import 'package:skyway_users/screens/unauthorizedPage.dart';

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
  Widget build(BuildContext context) {
    _provider = BlocProvider.of<AuthProvider>(context);
    _type = _provider.status;

    if (_type != "Usuario" && _type != "Tienda") {
      return UnauthorizedPage(info: "Por favor inicia sesión en la aplicación");
    }
    _name = (_type == "Usuario") ? _provider.user.name : _provider.shop.name;
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        //builder -> para que sea responsivo
        builder: (context, constraints) {
          return BackgroundWidget(
            constraints: constraints,
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
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('orders');
                    },
                    child: Text("Ordenes"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _provider.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                    },
                    child: Text("Cerrar sesión"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('search');
                    },
                    child: Text("Busqueda"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('profile');
                    },
                    child: Text("Mi perfil"),
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.bottomRight,
                    ),
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
