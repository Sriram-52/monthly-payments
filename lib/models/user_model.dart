class UserModel {
  String fullName;
  String? uId;

  UserModel({
    required this.fullName,
    this.uId,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : fullName = json["fullName"],
        uId = json["uId"];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["fullName"] = fullName;
    return map;
  }
}
