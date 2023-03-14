import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/chat_page/full_photo_page.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/utils/size_utils.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String emailId;
  String displayName;
  String profilePhotoURL;
  String phoneNumber;

  @override
  void initState() {
    getFacebookDetails();
    super.initState();
  }

  void getFacebookDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isKeyExist = prefs.getString(facebook_details);
    if (isKeyExist == null) {
      emailId = FirebaseAuth.instance.currentUser?.email;
      displayName = FirebaseAuth.instance.currentUser?.displayName;
      profilePhotoURL = FirebaseAuth.instance.currentUser?.photoURL;
      phoneNumber = FirebaseAuth.instance.currentUser?.phoneNumber;
      setState(() {});
    } else {
      String facebookData = await getPrefStringValue(facebook_details);
      print('facebook Data --> $facebookData');
      emailId = jsonDecode(facebookData)['email'];
      displayName = jsonDecode(facebookData)['name'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:commonAppbar(text: S.of(context).myProfileAppbar),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: height * 0.23,
                    width: width,
                    decoration: BoxDecoration(
                      color:  ColorResource.themeColor,
                    ),
                  ),
                  Container(
                    height: height * 0.643,
                    width: width,
                    decoration: BoxDecoration(
                      color:  ColorResource.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: height * 0.08),
                            child: Text(
                              displayName ?? '',
                              style: TextStyle(
                                color: ColorResource.themeColor,
                                fontSize: 15,
                              ),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: Text(
                              emailId ?? '',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:  ColorResource.themeColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                        Container(
                            margin: EdgeInsets.only(top: height * 0.02),
                            child: Text(
                              phoneNumber ?? '',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color:  ColorResource.themeColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: height * 0.13,
                left: width * 0.35,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPhotoPage(
                                  url: profilePhotoURL ??
                                      'assets/images/userProfile.png',
                                  appbarText: displayName ?? 'Dummy Name',
                                )));
                  },
                  child: CircleAvatar(
                    radius: width * 0.149,
                    backgroundColor:  ColorResource.themeColor,
                    child: CircleAvatar(
                      radius: width * 0.14,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: profilePhotoURL != null
                              ? Image.network(
                                  profilePhotoURL,
                                  height: height * 0.18,
                                  width: width * 0.32,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/userProfile.png',
                                  height: height * 0.18,
                                  width: width * 0.3,
                                  fit: BoxFit.cover,
                                )),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
