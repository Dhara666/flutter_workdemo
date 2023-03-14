class UserData {
  String email;
  String firstName;
  String lastName;
  String userID;
  String photoUrl;
  String date;
  String token;

  UserData({
    this.email,
    this.firstName,
    this.lastName,
    this.userID,
    this.photoUrl,
    this.date,
    this.token,
  });

  factory UserData.fromMap(Map<String, dynamic> map) => UserData(
        userID: map['userID'],
        email: map['email'],
        firstName: map['firstName'],
        lastName: map['lastName'],
        photoUrl: map['photoUrl'],
        date: map['date'],
        token: map['token'],
      );

  Map<String, dynamic> userMap() {
    return {
      'userID': userID,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'photoUrl': photoUrl,
      'date': date,
      'token': token,
    };
  }
}
