import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:skyway_users/models/collections/order.dart';
import 'package:skyway_users/models/collections/store.dart';
import 'package:skyway_users/models/collections/user.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

class AuthProvider extends Bloc {
  AuthProvider() : super(0);

  UserModel user;
  StoreModel shop;
  String status;

  @override
  Stream mapEventToState(event) async* {}

  Future<String> login(String email, String pass) async {
    final url = Uri.https(baseUri, "login", {
      "email": email,
      "password": pass,
    });
    final response = await http.get(url, headers: httpHeaders);
    if (response.statusCode == 200) {
      final resBody = json.decode(response.body);
      status = resBody["status"];
      final body = resBody["body"];
      print(resBody);
      if (status == "Usuario")
        this.user = UserModel.fromJson(body);
      else if (status == "Tienda") this.shop = StoreModel.fromJson(body);
      return status;
    }
    return null;
  }

  Future<String> savePersona(UserModel pModel) async {
    final url = Uri.https(baseUri, "registration/user");
    print(pModel.toJson());
    final response = await http.post(
      url,
      body: json.encode(pModel.toJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  Future<String> saveStore(StoreModel tModel) async {
    final url = Uri.https(baseUri, "registration/store");
    print(tModel.toJson());
    final response = await http.post(
      url,
      body: json.encode(tModel.toJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  Future<String> saveOrder(OrderModel oModel) async {
    final url = Uri.https(baseUri, "checkout");
    print(oModel.toJson());
    final response = await http.post(
      url,
      body: json.encode(oModel.toJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return response.body;
    return null;
  }

  Future<String> saveImage(Uint8List _image, String username) async {
    String path = "$username${DateTime.now().toIso8601String()}";
    fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
    fs.Reference refer = storage.ref("profile_images/$path");
    fs.TaskSnapshot ut = await refer.putData(_image);
    String url = await ut.ref.getDownloadURL();
    return url;
  }

  Future<void> logout() async {
    this.user = null;
    this.shop = null;
  }
}
