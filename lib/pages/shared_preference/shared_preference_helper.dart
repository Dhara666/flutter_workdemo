class UserModel {
  UserModel({
    this.userno,
    this.username,
    this.userdate,
  });

  String userno;
  String username;
  String userdate;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userno: json["userno"],
        username: json["username"],
        userdate: json["userdate"],
      );

  Map<String, dynamic> toJson() => {
        "userno": userno,
        "username": username,
        "userdate": userdate,
      };
}
