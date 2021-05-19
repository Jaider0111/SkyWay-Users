import 'package:flutter/foundation.dart';

class TiendaModel {
  String NombreTienda;
  String NIT;
  String Passwordt;
  List hora;
  String correot;
  String telt;
  String direcciont;
  String Categoria;

  TiendaModel(
      {@required this.NombreTienda,
      @required this.NIT,
      @required this.Categoria,
      @required this.Passwordt,
      @required this.hora,
      @required this.correot,
      @required this.telt,
      @required this.direcciont,})
      : super();

  Map<String, dynamic> ttoJson() {
    return {
    "identification" : NIT,
    "name" : NombreTienda ,
    "password" :  Passwordt ,
    "category" :  Categoria,
    "schedule" : hora,
    "phone" : telt,
    "email" : correot, 
    "address" : direcciont, 
    };
  }
}
