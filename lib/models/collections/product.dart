import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductModel {
  String id;
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
  double stars;

  ProductModel({
    @required this.name,
    @required this.description,
    @required this.category,
    @required this.subcategory,
    @required this.businessId,
    @required this.isCountable,
    this.amount,
    @required this.price,
    @required this.isCustomizable,
    this.options,
    @required this.images,
    this.stars,
  }) : super();

  ProductModel.fromJson(dynamic json) {
    this.id = json["id"];
    this.name = json["name"];
    this.description = json["description"];
    this.category = json["category"];
    this.subcategory = json["subcategory"];
    this.businessId = json["businessId"];
    this.isCountable = json["isCountable"];
    this.amount = json["amount"];
    this.price = json["price"];
    this.isCustomizable = json["isCustomizable"];
    this.options = (json["options"] as Map)?.cast<String, List<String>>();
    this.images = (json["images"] as List)?.cast<String>();
    this.stars = Random().nextDouble() * 5.0;
  }

  ProductModel.fromJson2(dynamic json) {
    this.name = json["name"];
    this.category = json["category"];
    this.price = json["price"];
    List dynList = json["images"];
    List<String> strList = dynList.map((s) => s as String).toList();
    this.images = strList;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
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
