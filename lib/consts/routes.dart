import 'package:flutter/material.dart';
import 'package:skyway_users/screens/new_product/add_product.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  'addProduct': (ctx) => AddProductPage(),
};
