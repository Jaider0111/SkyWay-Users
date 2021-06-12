import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/models/collections/user.dart';


class UsersProvider extends Bloc {
  UsersProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<UserModel> getUserById(String id) async {
    String url = "http://localhost:8080/api/consumers/get";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }
}