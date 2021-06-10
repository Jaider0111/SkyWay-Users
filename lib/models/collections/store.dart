import 'package:flutter/foundation.dart';

class StoreModel {
  String id;
  String name;
  String identification;
  String password;
  List schedule;
  String email;
  String phone;
  String address;
  String category;
  String image;

  StoreModel({
    @required this.name,
    @required this.identification,
    @required this.category,
    @required this.password,
    @required this.schedule,
    @required this.email,
    @required this.phone,
    @required this.address,
    this.image,
  }) : super();

  StoreModel.fromJson(dynamic json) {
    this.id = json["id"];
    this.name = json["name"];
    this.identification = json["identification"];
    this.category = json["category"];
    this.password = json["password"];
    this.email = json["email"];
    this.schedule = json["schedule"];
    this.phone = json["phone"];
    this.address = json["address"];
    this.image = json["image"];
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.id != null) "id": this.id,
      "identification": this.identification,
      "name": this.name,
      "password": this.password,
      "category": this.category,
      "schedule": this.schedule,
      "phone": this.phone,
      "email": this.email,
      "address": this.address,
      "image": this.image,
    };
  }
}
