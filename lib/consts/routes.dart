import 'package:flutter/material.dart';
import 'package:skyway_users/screens/Profile/profile.dart';
import 'package:skyway_users/screens/Registro/newRegistro.dart';
import 'package:skyway_users/screens/dashboard/dashboard.dart';
import 'package:skyway_users/screens/dashboard/dashboardBuyers.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';
import 'package:skyway_users/screens/orders/orders_manager.dart';
import 'package:skyway_users/screens/login/login.dart';
import 'package:skyway_users/screens/search/search.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'addProduct': (ctx) => AddProductPage(),
  'registration': (ctx) => RegistroPage(),
  'dashboard': (ctx) => DashBoardPage(),
  'dashboard_for_buyers': (ctx) => DashBoard2Page(),
  'login': (ctx) => Login(),
  'orders': (ctx) => OrdersManagerPage(),
  'search': (ctx) => SearchPage(),
  'profile': (ctx) => ProfilePage(),
};
