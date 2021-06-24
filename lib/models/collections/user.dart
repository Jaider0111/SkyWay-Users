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

  String fullName() {
    return this.name + " " + this.lastname;
  }

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



  UserModel.fromJson(dynamic json) {
    this.id = json["id"];
    this.email = json["email"];
    this.password = json["password"];
    this.name = json["first_name"];
    this.lastname = json["last_name"];
    this.address = json["address"];
    this.phone = json["phone"];
    this.identification = json["identification"];
    this.image = json["image"];
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
