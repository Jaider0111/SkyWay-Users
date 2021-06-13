import 'package:flutter/foundation.dart';

class OrderModel {
  String id;

  String status;
  Map<String, int> products;
  int total; // prices are int so total is int
  DateTime date;

  String consumerId;
  String businessId;

  OrderModel( { @required this.status,
                @required this.products,
                @required this.total,
                @required this.date,
                @required this.consumerId,
                @required this.businessId
  } ) : super();

  OrderModel.fromJson(dynamic json) {
    this.id = json["id"];
    this.status = json["status"];
    this.total = json["total"];
    this.date = json["date"];
    this.consumerId = json["consumerId"];
    this.businessId = json["businessId"];
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.id != null) "id": this.id,
      "status": this.status,
      "total": this.total,
      "date": this.date,
      "consumerId": this.consumerId,
      "businessId": this.businessId
    };
  }
}