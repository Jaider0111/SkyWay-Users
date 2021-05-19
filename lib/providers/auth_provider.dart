import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:skyway_users/models/collections/Tienda.dart';
import 'package:skyway_users/models/collections/user.dart';

class AuthProvider extends Bloc {
  AuthProvider() : super(0);

  UserModel user;

  @override
  Stream mapEventToState(event) async* {}

  Future<String> login(String email, String pass) async {
    final url = Uri.https(baseUri, "login", {
      "email": email,
      "password": pass,
    });
    final response = await http.get(url, headers: httpHeaders);
    print(response.body);
    if (response.statusCode == 200) {
      //final body = json.decode(response.body);
      //this.user = UserModel.fromJson(body);
      //return body["authentication"];
      return response.body;
    }
    return null;
  }

  Future<String> savePersona(UserModel pModel) async {
    final url = Uri.https(baseUri, "registration/user");
    print(pModel.ptoJson());
    final response = await http.post(
      url,
      body: json.encode(pModel.ptoJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  Future<String> saveStore(TiendaModel tModel) async {
    final url = Uri.https(baseUri, "registration/store");
    print(tModel.ttoJson());
    final response = await http.post(
      url,
      body: json.encode(tModel.ttoJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }
}
