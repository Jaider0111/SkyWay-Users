import 'package:flutter/foundation.dart';
import 'package:skyway_users/models/collections/product.dart';

class orderModel {
  String orderId;
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
  Map<ProductModel, int> products;
  int price;
  String status;
  String customerId;
  String businessId;

  orderModel(
      {@required this.orderId,
      @required this.name,
      @required this.address,
      @required this.floorApto,
      @required this.bonus,
      @required this.creditCard,
      this.creditCardNumber,
      this.cvv,
      this.month,
      this.year,
      this.pay,
      @required this.products,
      @required this.price,
      @required this.status,
      @required this.customerId,
      @required this.businessId})
      : super();

  orderModel.fromJson(dynamic json) {
    this.orderId = json["orderId"];
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
    this.products = json["products"];
    this.price = json["price"];
    this.status = json["status"];
    this.customerId = json["customerId"];
    this.businessId = json["businessId"];
  }

  Map<String, dynamic> toJson() {
    return {
      if (this.orderId != null) "orderId": this.orderId,
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
      "price": price,
      "status": status,
      "consumerId": customerId,
      "businessId": businessId
    };
  }
}
