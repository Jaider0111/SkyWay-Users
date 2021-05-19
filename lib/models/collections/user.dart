import 'package:flutter/foundation.dart';

class UserModel {
  String identification;
  String name;
  String lastname;
  String address;
  String email;
  String password;
  int phone;

  UserModel(
      {@required this.name,
      @required this.lastname,
      @required this.identification,
      @required this.address,
      @required this.email,
      @required this.password,
      @required this.phone})
      : super();

  UserModel.fromJson(Map<String, dynamic> map) {
    this.email = map["email"];
    this.password = map["password"];
    this.name = map["first_name"];
    this.lastname = map["last_name"];
    this.address = map["address"];
    this.phone = map["phone"];
    this.identification = map["identification"];
  }

  Map<String, dynamic> ptoJson() {
    return {
      "identification": this.identification,
      "first_name": this.name,
      "last_name": this.lastname,
      "address": this.address,
      "email": this.email,
      "password": this.password,
      "phone": this.phone
    };
  }
}
