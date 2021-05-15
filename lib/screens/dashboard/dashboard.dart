import 'package:flutter/material.dart';
import 'package:skyway_users/screens/appbar.dart';

class DashBoardPage extends StatefulWidget {
  DashBoardPage({Key key}) : super(key: key);

  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  @override
  Widget build(BuildContext context) {
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
                    //TODO: logout
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
