import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/common_widget/common_textFormFiled.dart';
import 'package:sheet_demo/constant/color_constant.dart';

import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference_helper.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference_homePage.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:sheet_demo/utils/validation.dart';
import 'package:toast/toast.dart';

class SharedPreferenceAddDetails extends StatefulWidget {
  final String no, name, date;
  final int index;
  final bool edit;
  SharedPreferenceAddDetails(
      {this.no, this.name, this.date, this.index, this.edit});

  @override
  _SharedPreferenceAddDetailsState createState() =>
      _SharedPreferenceAddDetailsState();
}

List<dynamic> userModelList = [];

class _SharedPreferenceAddDetailsState
    extends State<SharedPreferenceAddDetails> {
  final formKey = GlobalKey<FormState>();
  TextEditingController noController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<dynamic> sharedPrefUserData = [];

  @override
  void initState() {
    print("edit no : ${widget.no}");
    print("edit name : ${widget.name}");
    print("edit date : ${widget.date}");
    print("edit index : ${widget.index}");
    print('Edit mode --> ${widget.edit}');
    if (widget.edit == true) {
      noController.text = widget.no;
      nameController.text = widget.name;
      dateController.text = widget.date;
    }
    // TODO: implement initState
    super.initState();
  }

  selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorResource.themeColor,
              onSurface: ColorResource.grey,
            ),
            dialogBackgroundColor: ColorResource.white,
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(
          text: widget.edit == false ? S.of(context).sharedPrefAppbar: S.of(context).editProductAppbar),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              // height: height * 0.45,
              decoration: BoxDecoration(
                  color:  ColorResource.themeColor, borderRadius: BorderRadius.circular(15)),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                      bottom: height * 0.03,
                    ),
                    child: commonTextFormFiled(
                        labelText: CommonStrings.enterNo,
                        controller: noController,
                        type: TextInputType.number,
                        validator: (val) => validatePrefNo(val, context),
                        function: () {}),
                  ),
                  commonTextFormFiled(
                      labelText: CommonStrings.enterName,
                      controller: nameController,
                      type: TextInputType.text,
                      validator: (val) => validatePrefName(val, context),
                      function: () {}),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.03,
                      bottom: height * 0.03,
                    ),
                    child: commonTextFormFiled(
                        labelText: CommonStrings.selectDate,
                        controller: dateController,
                        validator: (val) => validatePrefDate(val, context),
                        function: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            selectDate(context);
                          });
                        }),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: width * 0.3,
                          right: width * 0.3,
                          top: height * 0.03),
                      child: commonMaterialButton(
                          text: widget.edit ? 'Update' : 'Save',
                          function: () async {
                            if (formKey.currentState.validate()) {
                              print('UserModels --> ${userModelList.asMap()}');
                              if (widget.edit) {
                                print('Index --> ${widget.index}');
                                userModelList.removeAt(widget.index);
                                userModelList.insert(
                                  widget.index,
                                  UserModel(
                                    userno: noController.text,
                                    username: nameController.text,
                                    userdate: dateController.text,
                                  ),
                                );
                                print(
                                    'Usermodel edit --> ${userModelList.asMap()}');
                                await removePrefValue(user_details);
                                await setPrefStringValue(user_details,
                                    jsonEncode(userModelList.toList()));
                                String dataValue =
                                    await getPrefStringValue(user_details);
                                print('Data --> $dataValue');
                                userModelList = jsonDecode(dataValue);
                                setState(() {});
                                Toast.show(
                                    CommonStrings.detailsEditSuccessfully,
                                    context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 3);
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SharedPreferenceHomePage()),
                                );
                              } else {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String isKeyExist =
                                    prefs.getString('user_details');
                                print('key Exist --> $isKeyExist');
                                if (isKeyExist != null) {
                                  String userDataString =
                                      await getPrefStringValue(user_details);
                                  if (userDataString.isNotEmpty) {
                                    sharedPrefUserData =
                                        jsonDecode(userDataString);
                                    print('Shared --> $sharedPrefUserData');
                                  }
                                  if (sharedPrefUserData.length == 0 &&
                                      userModelList.length == 0) {
                                    userModelList.add(UserModel(
                                        userno: noController.text,
                                        username: nameController.text,
                                        userdate: dateController.text));
                                  } else {
                                    userModelList = sharedPrefUserData;
                                    userModelList.add(UserModel(
                                        userno: noController.text,
                                        username: nameController.text,
                                        userdate: dateController.text));
                                  }
                                  print(
                                      'UserModel --> ${userModelList.asMap()}');
                                  await setPrefStringValue(user_details,
                                      jsonEncode(userModelList.toList()));
                                  Toast.show(
                                      CommonStrings.detailsAddedSuccessfully,
                                      context,
                                      backgroundColor: ColorResource.themeColor,
                                      textColor: ColorResource.white,
                                      duration: 3);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SharedPreferenceHomePage()),
                                  );
                                } else {
                                  userModelList.add(UserModel(
                                      userno: noController.text,
                                      username: nameController.text,
                                      userdate: dateController.text));
                                  print(
                                      'UserModel --> ${userModelList.asMap()}');
                                  var demo = await setPrefStringValue(
                                      user_details, jsonEncode(userModelList));
                                  print('demo value --> $demo');
                                  Toast.show(
                                      CommonStrings.detailsAddedSuccessfully,
                                      context,
                                      backgroundColor: ColorResource.themeColor,
                                      textColor: ColorResource.white,
                                      duration: 3);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SharedPreferenceHomePage()),
                                  );
                                }
                              }
                            }
                          })),
                  commonHeightBox(heightBox: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
