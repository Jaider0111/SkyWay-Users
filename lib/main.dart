import 'package:flutter/material.dart';
import 'package:skyway_users/consts/themes.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';

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
          title: Text('Skyway'),
        ),
        body: AddProductPage(),
      ),
    );
  }
}
