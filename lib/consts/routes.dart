import 'package:flutter/material.dart';
import 'package:skyway_users/screens/dashboard/dashboard.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'addProduct': (ctx) => AddProductPage(),
  'dashboard': (ctx) => DashBoardPage(),
};
