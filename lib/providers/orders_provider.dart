import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/core/utilities/http_info.dart';
import 'package:skyway_users/models/collections/order.dart';

class OrdersProvider extends Bloc {
  OrdersProvider() : super(0);

  @override
  Stream mapEventToState(event) async* {}

  Future<List> getOrders(String businessId, String consumerId) async {
    final url = Uri.https(baseUri, "api/orders/get", {
      "businessId": businessId,
      "consumerId": consumerId,
    });
    final response = await http.get(
      url,
      headers: httpHeaders,
    );
    if (response.statusCode == 200) return json.decode(response.body);
    return null;
  }

  Future<bool> update(OrderModel order) async {
    final url = Uri.https(baseUri, "/api/orders/update");
    print(order.toJson());
    final response = await http.put(
      url,
      body: json.encode(order.toJson()),
      headers: httpHeaders,
    );
    final ans = response.body;
    print(ans);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (ans == order.id) return true;
    }
    return false;
  }
}
