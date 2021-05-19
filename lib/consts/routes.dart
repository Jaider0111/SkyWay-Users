import 'package:flutter/material.dart';
import 'package:skyway_users/screens/Registro/newRegistro.dart';
import 'package:skyway_users/screens/dashboard/dashboard.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';
import 'package:skyway_users/screens/new_product/login.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'addProduct': (ctx) => AddProductPage(),
  'registration': (ctx) => RegistroPage(),
  'dashboard': (ctx) => DashBoardPage(),
  'login': (ctx) => Login1(),
};
