import 'dart:math';

import 'package:flutter/material.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/screens/appbar.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    title: 'SkyWay',
    theme: defaultTheme,
    home: Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return BackgroundWidget(
          constraints: constraints,
          child: Row(
            children: [
              NavigationBar(
                constraints: constraints,
              ),
            ],
          ),
        );
      }),
    ),
  ));
}

class NavigationBar extends StatelessWidget {
  final BoxConstraints constraints;
  const NavigationBar({
    Key key,
    @required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = constraints.maxWidth;
    //final height = constraints.maxHeight;
    return Card(
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: EdgeInsets.all(min(width / 50.0, 10.0)),
        child: Column(
          children: [
            BarItem(icon: Icons.shopping_cart),
            BarItem(icon: Icons.add_business),
          ],
        ),
      ),
    );
  }
}

class BarItem extends StatelessWidget {
  final IconData icon;

  const BarItem({
    Key key,
    @required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        CircleAvatar(
          radius: min(width / 15.0, 35.0),
          child: Icon(
            icon,
            size: min(50.0, width / 10.0),
          ),
        ),
        SizedBox(height: min(10.0, width / 70.0)),
      ],
    );
  }
}
