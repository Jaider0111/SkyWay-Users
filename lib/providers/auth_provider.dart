import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:http/http.dart' as http;
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
}
