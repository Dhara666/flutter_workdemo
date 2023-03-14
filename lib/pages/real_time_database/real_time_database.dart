import 'package:firebase_database/firebase_database.dart';
import 'package:sheet_demo/model/student_model.dart';

class Database {
  final DatabaseReference studentDatabase =
      FirebaseDatabase.instance.reference().child('Student_data');

  Query getStudentData() {
    return studentDatabase;
  }

  createStudentTable(StudentModel studentModel) {
    studentDatabase.push().set(studentModel.toJson());
  }

  updateStudentData(String tableName, StudentModel studentModel) {
    studentDatabase.child(tableName).update(studentModel.toJson());
  }

  deleteStudentData(String tableName) {
    studentDatabase.child(tableName).remove();
  }
}
