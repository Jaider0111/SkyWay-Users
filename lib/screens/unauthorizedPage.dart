import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skyway_users/screens/appbar.dart';

class UnauthorizedPage extends StatelessWidget {
  final String info;

  const UnauthorizedPage({
    Key key,
    @required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return BackgroundWidget(
            constraints: constraints,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Acceso denegado:"),
                  TextButton(
                    child: Text(
                      info,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue[700],
                        color: Colors.blue[700],
                      ),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false),
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
