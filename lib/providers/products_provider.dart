import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:skyway_users/models/collections/product.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as fs;

class ProductsProvider extends Bloc {
  ProductsProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<bool> saveProduct(ProductModel productModel) async {
    final url = Uri.https(baseUri, "/api/products/create");
    print(productModel.toJson());
    final response = await http.post(
      url,
      body: json.encode(productModel.toJson()),
      headers: httpHeaders,
    );
    print(response.body);
    if (response.statusCode == 200) return true;
    return false;
  }

  Future<List<String>> saveImages(
      List<Uint8List> _images, String productName) async {
    List<String> urls = [];
    String path = "$productName${DateTime.now().toIso8601String()}";
    fs.FirebaseStorage storage = fs.FirebaseStorage.instance;
    fs.Reference refer;
    for (int i = 0; i < _images.length; i++) {
      refer = storage.ref("products_images/$path$i");
      fs.TaskSnapshot ut = await refer.putData(_images[i]);
      String url = await ut.ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  Future<Uint8List> getImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.bodyBytes;
    return null;
  }

  Future<List<String>> searchProducts(String search) async {
    final url = Uri.https(baseUri, "api/products/name", {"regex": search});
    final response = await http.get(
      url,
      //Uri.http("127.0.0.1:8080", "api/products/name", {"regex": search}),
      headers: httpHeaders,
    );

    if (response.statusCode == 200) {
      List ans = json.decode(response.body);
      ans = ans.map((e) => e.toString()).toList();
      return ans;
    }
    return [];
  }

  Future<List<String>> searchProductsByCatOrSubcat(String category, String subcategory) async {
    //final url = Uri.https(baseUri, "api/products/category", {"category": category, "subcategory" : subcategory,});
    final response = await http.get(
      //url,
      Uri.http("127.0.0.1:8080", "api/products/category", {
        "category": category,
        "subcategory": subcategory,
      }),
      headers: httpHeaders,
    );

    if (response.statusCode == 200) {
      List ans = json.decode(response.body);
      ans = ans.map((e) => e.toString()).toList();
      return ans;
    }
    return [];
  }

  Future<ProductModel> getProductById(String id) async {
    final url = Uri.https(baseUri, "api/products", {"id": id});
    final response = await http.get(
      url,
      //Uri.http("127.0.0.1:8080", "api/products", {"id": id}),
      headers: httpHeaders,
    );
    if (response.statusCode == 200) {
      ProductModel ans = ProductModel.fromJson(json.decode(response.body));
      return ans;
    }
    return null;
  }

  Future<List> getProducts() async {
    //String url = "http://localhost:8080/api/getProducts";
    //final response = await http.get(Uri.parse(url));
    final url = Uri.https(baseUri, "/api/getProducts");
    final response = await http.get(url);
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }
}
