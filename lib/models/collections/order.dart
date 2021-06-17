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
      if (this.id != null) "id": this.id,
      "name": name,
      "address": address,
      "floorApto": floorApto,
      "bonus": bonus,
      "withCreditCard": creditCard,
      "creditCardNumber": creditCardNumber,
      "cvv": cvv,
      "month": month,
      "year": year,
      "pay": pay,
      "products": products.toString(),
      "total": total,
      "status": status,
      "consumerId": this.consumerId,
      "businessId": businessId,
      "date": date.toIso8601String(),
    };
  }
}
