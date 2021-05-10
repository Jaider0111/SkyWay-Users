import 'package:flutter/foundation.dart';

class ProductoModel {
  String name;
  String description;
  bool isCountable;
  int amount;
  int price;
  bool isCustomizable;
  List<String> images;
  Map<String, List<String>> options;

  ProductoModel(
      {@required this.name,
      @required this.description,
      @required this.isCountable,
      this.amount,
      @required this.price,
      @required this.isCustomizable,
      this.options,
      @required this.images})
      : super();
}
