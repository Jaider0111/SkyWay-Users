import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:skyway_users/core/utilities/http_info.dart';


class OrdersProvider extends Bloc {
    OrdersProvider() : super(0);
    
    @override
    Stream mapEventToState(event) async* {}
  
    Future<List> getOrders(String businessId) async {
      final url = Uri.http("localhost:8080", "api/orders/get", {"businessId": businessId});
      final response = await http.get(
        url,
        headers: httpHeaders,
      );
      if (response.statusCode == 200) return json.decode(response.body);
      return null;
    }
  
}