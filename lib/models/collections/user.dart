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
    this.email = map["correo"];
    this.password = map["contrasena"];
    this.name = map["nombres"];
    this.lastname = map["apellidos"];
    this.address = map["direccion"];
    this.phone = map["telefono"];
  }
}
