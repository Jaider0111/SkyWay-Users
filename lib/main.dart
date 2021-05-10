import 'package:flutter/material.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/screens/new_product/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyWay',
      theme: defaultTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'SkyWay',
            style: TextStyle(fontSize: 30, fontFamily: "Pacifica"),
          ),
        ),
        body: Login(),
      ),
    );
  }
}
