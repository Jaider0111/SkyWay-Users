import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/core/utilities/httpRT.dart';
import 'package:skyway_users/models/collections/Tienda.dart';
import 'package:skyway_users/models/collections/persona.dart';

class RegistroProvider extends Bloc {
  RegistroProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<bool> savePersona(PersonaModel pModel) async {
    final url = Uri.https(baseUrip, "/registration/user");
    print(pModel.ptoJson());
    final response = await http.post(
      url,
      body: json.encode(pModel.ptoJson()),
      headers: httpHeadersr,
    );
    print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<bool> saveStore(TiendaModel tModel) async {
    final url = Uri.https(baseUrip, "/registration/store");
    print(tModel.ttoJson());
    final response = await http.post(
      url,
      body: json.encode(tModel.ttoJson()),
      headers: httpHeadersr,
    );
    print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }
}
