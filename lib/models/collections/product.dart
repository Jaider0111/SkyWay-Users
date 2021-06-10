import 'dart:convert';

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
    this.options = (json["options"] as Map).map((key, value) =>
        MapEntry(key.toString(), (value as List).map((e) => e.toString()).toList()));
    this.images = (json["images"] as List).map((e) => e.toString()).toList();
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
      if (this.id != null) "id": this.id,
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
