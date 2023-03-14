import 'dart:async';
import 'dart:collection';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sheet_demo/pages/sqlite_database/database/model/user.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, productname TEXT, productprice TEXT, productdiscount TEXT,producttax TEXT,productimage BLOB,productSubTotal TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<List<User>> getUser() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
    List<User> employees = [];
    for (int i = 0; i < list.length; i++) {
      var user = User(
        list[i]["productname"],
        list[i]["productprice"],
        list[i]["productdiscount"],
        list[i]["producttax"],
        list[i]["productimage"],
        list[i]['productSubTotal'],
      );
      user.setUserId(list[i]["id"]);
      employees.add(user);
    }
    print(employees.length);
    return employees;
  }

  Future<int> deleteUsers(User user) async {
    var dbClient = await db;

    int res =
        await dbClient.rawDelete('DELETE FROM User WHERE id = ?', [user.id]);
    return res;
  }

  Future<bool> update(User user) async {
    var dbClient = await db;

    int res = await dbClient.update("User", user.toMap(),
        where: "id = ?", whereArgs: <int>[user.id]);
    print("user id" + user.id.toString());

    return res > 0 ? true : false;
  }

// Future<bool> updateCart({int done, id}) async {
//   var dbClient = await db;
//
//   int res = await dbClient.rawUpdate('''
//   UPDATE User
//   SET done = ?
//   WHERE id = ?
//   ''', [done, id]);
//   print("user id" + id.toString());
//   return res > 0 ? true : false;
// }
}

class CartModel extends ChangeNotifier {
  List<User> employees = [];

  UnmodifiableListView<User> get items => UnmodifiableListView(employees);

  void addItem(int id, User item) {
    employees.add(item);
    notifyListeners();
  }

  void clearItem() {
    employees.clear();
    notifyListeners();
  }

  void deleteItem(User item) {
    employees.remove(item);
    notifyListeners();
  }
}
