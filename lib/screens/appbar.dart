import 'package:flutter/material.dart';

final appBar = AppBar(
  elevation: 4.0,
  backgroundColor: Colors.black,
  centerTitle: true,
  title: Text(
    'SkyWay',
    style: TextStyle(fontSize: 30, fontFamily: "Pacifica"),
  ),
);

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;

  const BackgroundWidget({
    Key key,
    @required this.constraints,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: constraints.maxHeight,
      width: constraints.maxWidth,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.deepOrange,
          Colors.deepPurple,
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )),
      child: child,
    );
  }
}
