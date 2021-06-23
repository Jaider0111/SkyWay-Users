import 'package:flutter/foundation.dart';

class OrderModel {
  String id;
  String name;
  String address;
  String floorApto;
  int bonus;
  bool creditCard;
  String creditCardNumber;
  int cvv;
  int month;
  int year;
  int pay;
  Map<String, int> products;
  int total;
  String status;
  String consumerId;
  String businessId;
  DateTime date;

  OrderModel(
      {@required this.id,
      @required this.name,
      @required this.address,
      @required this.floorApto,
      @required this.bonus,
      @required this.date,
      @required this.creditCard,
      this.creditCardNumber,
      this.cvv,
      this.month,
      this.year,
      this.pay,
      @required this.products,
      @required this.total,
      @required this.status,
      @required this.consumerId,
      @required this.businessId})
      : super();

  OrderModel.fromJson(dynamic json) {
    this.id = json["id"];
    this.name = json["name"];
    this.address = json["address"];
    this.floorApto = json["floorApto"];
    this.bonus = json["bonus"];
    this.creditCard = json["withCreditCard"];
    this.creditCardNumber = json["creditCardNumber"];
    this.cvv = json["cvv"];
    this.month = json["month"];
    this.year = json["year"];
    this.pay = json["pay"];
    this.products = (json["products"] as Map).cast<String, int>();
    this.date = DateTime.tryParse(json["date"]);
    this.total = json["total"];
    this.status = json["status"];
    this.businessId = json["businessId"];
    this.consumerId = json["consumerId"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "address": this.address,
      "floorApto": this.floorApto,
      "bonus": this.bonus,
      "creditCard": this.creditCard,
      "creditCardNumber": this.creditCardNumber,
      "cvv": this.cvv,
      "month": this.month,
      "year": this.year,
      "pay": this.pay,
      "products": this.products,
      "total": this.total,
      "status": this.status,
      "consumerId": this.consumerId,
      "businessId": this.businessId,
      "date": date.toIso8601String(),
    };
  }
}
