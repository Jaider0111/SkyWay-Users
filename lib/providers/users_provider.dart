import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/models/collections/user.dart';
import 'package:skyway_users/core/utilities/http_info.dart';


class UsersProvider extends Bloc {
  UsersProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<UserModel> getUserById(String id) async {
    final url = Uri.http("localhost:8080", "api/consumers/get", {"id": id});
    final response = await http.get(
      url,
      headers: httpHeaders,
    );

    if (response.statusCode == 200) {
      UserModel ans = UserModel.fromJson(json.decode(response.body));
      return ans;
    }
    return null;
  }
}