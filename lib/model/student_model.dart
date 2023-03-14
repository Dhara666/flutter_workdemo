import 'package:intl/intl.dart';

class StudentModel {
  String name;
  String rollNo;
  String createdAt;

  StudentModel({this.name, this.rollNo, this.createdAt});

  factory StudentModel.fromJson(Map<dynamic, dynamic> json) => StudentModel(
        name: json['name'],
        rollNo: json['rollNo'],
        createdAt: json['createdAt'],
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rollNo': rollNo,
      'createdAt': createdAt,
    };
  }

  String getDate() {
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(DateTime.now());
  }
}
