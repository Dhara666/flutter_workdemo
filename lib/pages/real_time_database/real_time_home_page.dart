import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/real_time_database/add_details_page.dart';
import 'package:sheet_demo/pages/real_time_database/real_time_database.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class RealTimeHomePage extends StatefulWidget {
  @override
  RealTimeHomePageState createState() => new RealTimeHomePageState();
}

class RealTimeHomePageState extends State<RealTimeHomePage> {
  Database database = Database();

  @override
  Widget build(BuildContext context) {
    print('Current screen --> $runtimeType');
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).realTimeDatabaseAppbar),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FirebaseAnimatedList(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              query: database.getStudentData(),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddNamePage(
                          tableName: snapshot.key,
                          studentModel: snapshot.value,
                          isEdit: true,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    snapshot.value['rollNo'],
                    style: TextStyle(color: ColorResource.themeColor),
                  ),
                  subtitle: Text(
                    snapshot.value['name'],
                    style: TextStyle(color: ColorResource.themeColor),
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      await database.deleteStudentData(snapshot.key);
                    },
                    child: Icon(
                      Icons.delete,
                      color: ColorResource.themeColor,
                    ),
                  ),
                );
              },
            ),
            commonHeightBox(heightBox: height * 0.14)
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.03),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          elevation: 0,
          backgroundColor: ColorResource.themeColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNamePage()),
            );
          },
        ),
      ),
    );
  }
}
