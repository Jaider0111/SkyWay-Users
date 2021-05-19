import 'package:flutter/material.dart';
import 'package:skyway_users/screens/appbar.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  String _type;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments ?? {};
    if (args.containsKey("user"))
      _type = args["user"];
    else
      _type = "Tienda";
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Binvenido a SkyWay"),
                if (_type == "Tienda")
                  ElevatedButton(
                    onPressed: () {
                      //TODO: businessId
                      Navigator.of(context).pushNamed('addProduct', arguments: {
                        "businessId": "businessIdDashboard",
                      });
                    },
                    child: Text("Agregar Producto"),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
                  },
                  child: Text("Cerrar sesión"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
