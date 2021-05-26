import 'package:flutter/foundation.dart';

class UserModel {
  String id;
  String identification;
  String name;
  String lastname;
  String address;
  String email;
  String password;
  String image;
  String phone;

  UserModel({
    @required this.name,
    @required this.lastname,
    @required this.identification,
    @required this.address,
    @required this.email,
    @required this.password,
    @required this.phone,
    this.image,
  }) : super();

  UserModel.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.email = map["email"];
    this.password = map["password"];
    this.name = map["first_name"];
    this.lastname = map["last_name"];
    this.address = map["address"];
    this.phone = map["phone"];
    this.identification = map["identification"];
    this.image = map["image"];
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.id != null) "id": this.id,
      "identification": this.identification,
      "first_name": this.name,
      "last_name": this.lastname,
      "address": this.address,
      "email": this.email,
      "password": this.password,
      "phone": this.phone,
      "image": this.image,
    };
  }
}
