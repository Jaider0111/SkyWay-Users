import 'package:flutter/foundation.dart';

class PersonaModel {
  String Nombre;
  String Apellidos;
  String Doc;
  String Correo;
  String Tel;
  String dir;
  String Password;

  PersonaModel(
      {@required this.Nombre,
      @required this.Apellidos,
      @required this.Doc,
      @required this.Correo,
      @required this.Tel,
      @required this.dir,
      @required this.Password,
})
      : super();

  Map<String, dynamic> ptoJson() {
    return {
      "identification": this.Doc,
      "name": this.Nombre,
      "lastname": this.Apellidos,
      "address": this.dir,
      "email": this.Correo,
      "password": this.Password,
      "phone": this.Tel
    };
  }
}
