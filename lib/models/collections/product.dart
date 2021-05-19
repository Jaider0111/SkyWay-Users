import 'package:flutter/foundation.dart';

class ProductModel {
  String name;
  String description;
  String category;
  String subcategory;
  String businessId;
  bool isCountable;
  int amount;
  int price;
  bool isCustomizable;
  List<String> images;
  Map<String, List<String>> options;

  ProductModel(
      {@required this.name,
      @required this.description,
      @required this.category,
      @required this.subcategory,
      @required this.businessId,
      @required this.isCountable,
      this.amount,
      @required this.price,
      @required this.isCustomizable,
      this.options,
      @required this.images})
      : super();

  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "description": this.description,
      "category": this.category,
      "subcategory": this.subcategory,
      "businessId": this.businessId,
      "isCountable": this.isCountable,
      if (isCountable) "amount": this.amount,
      "price": this.price,
      "isCustomizable": this.isCustomizable,
      if (isCustomizable) "options": this.options,
      "images": this.images,
    };
  }
}
