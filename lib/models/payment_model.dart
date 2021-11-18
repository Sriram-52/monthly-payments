import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  Timestamp? createdAt;
  String description;
  String title;
  num rate;
  int quantity;
  String uId;
  Timestamp purchasedDate;
  String paymentMadeBy;
  String? id;
  List users;

  PaymentModel({
    this.createdAt,
    required this.description,
    required this.rate,
    required this.uId,
    required this.quantity,
    required this.purchasedDate,
    required this.paymentMadeBy,
    required this.users,
    required this.title,
    this.id,
  });

  PaymentModel.fromJson(Map<String, dynamic> json)
      : createdAt = json["createdAt"],
        description = json["description"],
        rate = json["rate"],
        id = json["id"],
        purchasedDate = json["purchasedDate"],
        quantity = json["quantity"],
        paymentMadeBy = json["paymentMadeBy"],
        users = json["users"],
        title = json["title"],
        uId = json["uId"];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["cretedAt"] = Timestamp.now();
    map["description"] = description;
    map["rate"] = rate;
    map["quantity"] = quantity;
    map["uId"] = uId;
    map["purchasedDate"] = purchasedDate;
    map["paymentMadeBy"] = paymentMadeBy;
    map["users"] = users;
    map["title"] = title;
    return map;
  }
}
