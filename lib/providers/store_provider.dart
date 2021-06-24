import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/models/collections/store.dart';

class StoreProvider extends Bloc {
  StoreProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<List<String>> searchStoresByCategory(String category) async {
    final url = Uri.https(
      baseUri,
      "api/stores/category",
      {
        "category": category,
      },
    );
    final response = await http.get(
      url,
      headers: httpHeaders,
    );

    if (response.statusCode == 200) {
      List ans = json.decode(response.body);
      ans = ans.map((e) => e.toString()).toList();
      return ans;
    }
    return [];
  }

  Future<StoreModel> getStoreById(String id) async {
    final url = Uri.https(baseUri, "api/stores/get", {"id": id});
    final response = await http.get(
      url,
      headers: httpHeaders,
    );
    if (response.statusCode == 200) {
      StoreModel ans = StoreModel.fromJson(json.decode(response.body));
      return ans;
    }
    return null;
  }
}
