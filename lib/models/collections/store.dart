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

  StoreModel({
    @required this.name,
    @required this.identification,
    @required this.category,
    @required this.password,
    @required this.schedule,
    @required this.email,
    @required this.phone,
    @required this.address,
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
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.id != null) "id": this.id,
      "identification": identification,
      "name": name,
      "password": password,
      "category": category,
      "schedule": schedule,
      "phone": phone,
      "email": email,
      "address": address,
    };
  }
}
