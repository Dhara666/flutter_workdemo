import 'dart:async';

import 'package:sheet_demo/pages/sqlite_database/database/model/database_helper.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/user.dart';

abstract class HomeContract {
  void screenUpdate();
}

class HomePresenter {
  HomeContract _view;

  var db = DatabaseHelper();

  HomePresenter(this._view);

  delete(User user) {
    var db = DatabaseHelper();
    db.deleteUsers(user);
    updateScreen();
  }

  Future<List<User>> getUser() {
    return db.getUser();
  }

  updateScreen() {
    _view.screenUpdate();
  }
}
