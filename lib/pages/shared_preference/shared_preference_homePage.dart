import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference_add_detail.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class SharedPreferenceHomePage extends StatefulWidget {
  @override
  _SharedPreferenceHomePageState createState() =>
      _SharedPreferenceHomePageState();
}

class _SharedPreferenceHomePageState extends State<SharedPreferenceHomePage> {
  List<dynamic> userData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    print('UserData --> ${userData.asMap()}');
    String value = await getPrefStringValue(user_details);
    print("value--->$value");
    setState(() {
      if (value.isNotEmpty) userData = jsonDecode(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(text: S.of(context).addDetailsPageAppbar),
      body: userData.length != 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(height * 0.02),
                        // height: height * 0.2,
                        decoration: BoxDecoration(
                          color: ColorResource.themeColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  commonHeightBox(heightBox: 10),
                                  userData.length == 0
                                      ? Text('Hello')
                                      : commonSharedText(
                                          text:
                                              "User No : ${userData[index]['userno']}",
                                        ),
                                  commonSharedText(
                                    text:
                                        "User Name : ${userData[index]['username']}",
                                  ),
                                  commonSharedText(
                                    text:
                                        "User Date : ${userData[index]['userdate']}",
                                  ),
                                  commonHeightBox(heightBox: 10),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SharedPreferenceAddDetails(
                                                    index: index,
                                                    no: userData[index]
                                                        ['userno'],
                                                    name: userData[index]
                                                        ['username'],
                                                    date: userData[index]
                                                        ['userdate'],
                                                    edit: true,
                                                  ))).then(
                                          (value) => setState(() {}));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: ColorResource.white,
                                    )),
                                IconButton(
                                  onPressed: () async {
                                    print('UserData --> ${userData.toList()}');
                                    userData.removeAt(index);
                                    print('UserData --> ${userData.toList()}');
                                    await removePrefValue(user_details);
                                    await setPrefStringValue(user_details,
                                        jsonEncode(userData.toList()));
                                    String dataValue =
                                        await getPrefStringValue(user_details);
                                    print('Data --> $dataValue');
                                    userData = jsonDecode(dataValue);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorResource.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  commonHeightBox(heightBox: height * 0.13)
                ],
              ),
            )
          : Container(),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.03),
        child: FloatingActionButton(
          backgroundColor: ColorResource.themeColor,
          elevation: 0,
          child: Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SharedPreferenceAddDetails(edit: false)));
          },
        ),
      ),
    );
  }
}
