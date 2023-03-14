import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/constant/string_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/Views_page.dart';
import 'package:sheet_demo/pages/audio_player_page.dart';
import 'package:sheet_demo/pages/choice_chip_page.dart';
import 'package:sheet_demo/pages/homePage.dart';
import 'package:sheet_demo/pages/my_profile_page.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/sign_in_page.dart';
import 'package:sheet_demo/services/auth_services.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:toast/toast.dart';

class MainPage extends StatefulWidget {
  final String email, password;
  final String currentUserId;

  MainPage({this.email, this.password, this.currentUserId});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var emailId = FirebaseAuth.instance.currentUser?.email;
  bool checkBox = false;
  int val = -1;
  String chooseValue;

  TabController tabController;

  @override
  Widget build(BuildContext context) {
    size(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: ColorResource.white,
        appBar: AppBar(
          leadingWidth: 30,
          title: Text(
            S.of(context).homePageAppbar,
          ),
          actions: [
            DropdownButton(
              dropdownColor: ColorResource.themeColor,
              value: chooseValue,
              style: TextStyle(color: ColorResource.white),
              iconEnabledColor: ColorResource.white,
              items: <String>[
                'English',
                'Hindi',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: ColorResource.white),
                  ),
                );
              }).toList(),
              hint: Text(
                'language',
                style: TextStyle(
                    color: ColorResource.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (String value) {
                setState(() {
                  chooseValue = value;
                  _select(value);
                });
              },
            ),
          ],
          bottom: TabBar(
            labelPadding: EdgeInsets.all(0),
            indicatorColor: ColorResource.white,
            indicatorPadding: EdgeInsets.only(bottom: 14),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle:
                TextStyle(fontFamily: FontString.mont, fontSize: 5),
            labelColor: ColorResource.themeColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              commonTab(text: S.of(context).tabHome),
              commonTab(text: S.of(context).tabView),
              commonTab(text: S.of(context).tabAudioPlayer),
              commonTab(text: S.of(context).tabChips),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Image.asset('assets/images/slider5.png'),
              commonHeightBox(heightBox: height * 0.02),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: width * 0.025),
                  child: ListTile(
                    title: Text(S.of(context).myProfile,style: TextStyle(color: ColorResource.themeColor),),
                    leading: Icon(Icons.account_circle,color: ColorResource.themeColor,),
                    minLeadingWidth: 10,
                  ),
                ),
              ),
              Divider(),
              commonHeightBox(heightBox: height * 0.015),
              commonText(
                  text: 'Radio ListTile', color: ColorResource.themeColor),
              RadioListTile(
                value: 1,
                groupValue: val,
                activeColor: ColorResource.themeColor,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                },
                title: Text("Radio",style: TextStyle(color: ColorResource.themeColor)),
                subtitle: Text("caption/subtext",style: TextStyle(color: ColorResource.themeColor)),
                secondary: Icon(Icons.sd_storage,color: ColorResource.themeColor,),
                toggleable: true,
                // controlAffinity: ListTileControlAffinity.leading,
              ),
              Divider(),
              commonHeightBox(heightBox: height * 0.015),
              commonText(
                  text: 'CheckboxListTile', color: ColorResource.themeColor),
              CheckboxListTile(
                activeColor: ColorResource.themeColor,
                title:  Text('Animate Slowly',style: TextStyle(color: ColorResource.themeColor)),
                value: checkBox,
                onChanged: (bool value) {
                  setState(() {
                    checkBox = !checkBox;
                    //timeDilation = value ? 10 : 1.0;
                  });
                },
                secondary: Icon(Icons.hourglass_empty,color: ColorResource.themeColor,),
              ),
              Divider(),
              commonHeightBox(heightBox: height * 0.015),
              commonText(text: 'Alert Dialog', color: ColorResource.themeColor),
              InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: ListTile(
                  title: Text(S.of(context).logOut,style: TextStyle(color: ColorResource.themeColor)),
                  leading: Icon(Icons.logout,color: ColorResource.themeColor,),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: <Widget>[
            HomePage(),
            ViewsPage(),
            AudioPlayerPage(),
            ChoiceChipPage()
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget yesButton = TextButton(
        child: Text(
          S.of(context).yes,
          style: TextStyle(color: ColorResource.themeColor),
        ),
        onPressed: () async {
          EasyLoading.show(indicator: commonIndicator());
          await FirebaseAuth.instance.signOut();
          await removePrefValue(is_logIn);
          await removePrefValue(user_details);
          await removePrefValue(facebook_details);
          AuthService().signOutGoogle(context);
          AuthService().signOutFacebook(context);
          Navigator.pop(context);
          EasyLoading.dismiss();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInPage()));
          Toast.show(S.of(context).signUp, context,
              backgroundColor: ColorResource.white,
              textColor: ColorResource.themeColor,
              duration: 10);
        });
    Widget cancelButton = TextButton(
      child: Text(
        S.of(context).cancel,
        style: TextStyle(color: ColorResource.themeColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        S.of(context).areYouSureYouWantToLogOut,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
      actions: [
        cancelButton,
        yesButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget commonTab({String text}) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: ColorResource.white),
      ),
    );
  }

  void _select(String language) {
    setState(() {
      if (language == "Hindi") {
        S.load(
          Locale.fromSubtags(languageCode: 'pt', countryCode: 'IN'),
        );
      } else {
        S.load(
          Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
        );
      }
    });
  }
}
