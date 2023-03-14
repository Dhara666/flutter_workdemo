import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sheet_demo/model/user_data_model.dart';

class UserServices {
  CollectionReference userTable = FirebaseFirestore.instance.collection("user");

  Future createUser(UserData userData) async {
    try {
      await userTable.doc(userData.userID).set(userData.userMap());
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
