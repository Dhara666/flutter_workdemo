import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/common_widget/common_text.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/model/user_data_model.dart';
import 'package:sheet_demo/pages/api_demo_pages/demo_page_api_screen.dart';
import 'package:sheet_demo/pages/audio_player_page.dart';
import 'package:sheet_demo/pages/chat_page/chat_home_page.dart';
import 'package:sheet_demo/pages/geolocation_pages/google_map_page.dart';
import 'package:sheet_demo/pages/global_listview/show_global_details.dart';
import 'package:sheet_demo/pages/in_app_purchase/payment_page.dart';
import 'package:sheet_demo/pages/notification_pages/notification_option_page.dart';
import 'package:sheet_demo/pages/qr_code_scanner/qr_code_scanner_page.dart';
import 'package:sheet_demo/pages/real_time_database/real_time_home_page.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference_homePage.dart';
import 'package:sheet_demo/pages/sign_in_page.dart';
import 'package:sheet_demo/pages/sqlite_database/show_product_page.dart';
import 'package:sheet_demo/pages/state_management/state_management_page/state_management_option_page.dart';
import 'package:sheet_demo/services/auth_services.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentUid = FirebaseAuth.instance.currentUser?.uid;
  File imageFile;
  final picker = ImagePicker();

  getImageGallery() async {
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    } else {
      print('No Image Selected');
    }
  }

  getImageCamera() async {
    PickedFile pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      setState(() {});
    } else {
      print('No Image Selected');
    }
  }

  bool isSwitch = false;
  bool hideWidget = false;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.fromDateTime(DateTime.now());

  _selectDate(BuildContext context) async {
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

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
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
        context: context,
        initialTime: selectedTime);
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    size(context);
    print('Current page --> $runtimeType');

    return Scaffold(
      backgroundColor: ColorResource.white,
      body: ListView(
        children: [
          commonHeightBox(heightBox: height * 0.015),
          commonText(
              text: S.of(context).circleImageStack,
              color: ColorResource.themeColor),
          Align(
            alignment: Alignment.topLeft,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.02,
                      top: height * 0.015,
                      bottom: height * 0.015),
                  child: CircleAvatar(
                    radius: width * 0.13,
                    backgroundColor: ColorResource.themeColor,
                    child: CircleAvatar(
                        backgroundColor: ColorResource.white,
                        radius: width * 0.125,
                        child: imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.file(
                                  imageFile,
                                  width: width * 0.35,
                                  height: height * 0.35,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Text(
                                S.of(context).noImage,
                                style:
                                    TextStyle(color: ColorResource.themeColor),
                              )),
                  ),
                ),
                Positioned(
                  left: width * 0.215,
                  top: height * 0.03,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                S.of(context).selectImageSource,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            content: Container(
                              height: height * 0.15,
                              child: Column(
                                children: [
                                  commonMaterialButton(
                                      text: S.of(context).camera,
                                      function: () {
                                        getImageCamera();
                                        Navigator.pop(context);
                                      }),
                                  commonMaterialButton(
                                      text: S.of(context).gallery,
                                      function: () {
                                        getImageGallery();
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      setState(() {});
                    },
                    child: Container(
                        height: height * 0.04,
                        width: height * 0.035,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResource.themeColor,
                        ),
                        child: Center(
                            child: Icon(
                          Icons.image,
                          color: ColorResource.white,
                          size: 17,
                        ))),
                  ),
                )
              ],
            ),
          ),
          commonText(
              text: S.of(context).switch1, color: ColorResource.themeColor),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Switch(
                    value: isSwitch,
                    onChanged: (value) {
                      setState(() {
                        isSwitch = value;
                        print(isSwitch);
                        imageFile ??
                            Toast.show(S.of(context).pleaseSelectImage, context,
                                backgroundColor: ColorResource.themeColor,
                                textColor: ColorResource.white);
                      });
                    },
                    inactiveThumbColor: ColorResource.themeColor,
                    activeColor: ColorResource.themeColor,
                    inactiveTrackColor: Color(0xffc79ebc),
                  ),
                ),
                isSwitch == true
                    ? Container(
                        margin: EdgeInsets.only(left: width * 0.03),
                        child: imageFile != null
                            ? Image.file(
                                imageFile,
                                width: width * 0.15,
                                height: height * 0.15,
                                fit: BoxFit.cover,
                              )
                            : commonIndicator())
                    : Container(),
              ],
            ),
          ),
          commonText(
              text: S.of(context).datePicker, color: ColorResource.themeColor),
          Container(
            margin: EdgeInsets.only(left: width * 0.09, right: width * 0.27),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: ColorResource.white),
                  borderRadius: BorderRadius.circular(15)),
              onPressed: () => _selectDate(context),
              color: ColorResource.themeColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).selectDate,
                    style: TextStyle(color: ColorResource.white),
                  ),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    // selectedDate.month.toString(),
                    style: TextStyle(color: ColorResource.white),
                  ),
                ],
              ),
            ),
          ),
          commonHeightBox(heightBox: height * 0.03),
          commonText(
              text: S.of(context).timePicker, color: ColorResource.themeColor),
          Container(
            margin: EdgeInsets.only(left: width * 0.09, right: width * 0.27),
            child: MaterialButton(
              onPressed: () {
                _selectTime(context);
                print(
                  selectedTime.format(context),
                );
              },
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: ColorResource.white),
                  borderRadius: BorderRadius.circular(15)),
              color: ColorResource.themeColor,
              child: Text(
                "${S.of(context).selectTime} - ${selectedTime.format(context)}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // commonHeightBox(heightBox: height * 0),
          // Align(
          //   alignment: Alignment.topLeft,
          //   child: Container(
          //     margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
          //     child: commonMaterialButton(
          //         text: S.of(context).hideShow,
          //         function: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => HideShowPage()));
          //         }),
          //   ),
          // ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).globalListView,
                  function: () {
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowGlobalDetails()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).sqfliteDatabase,
                  function: () {
                    setState(() {});
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowProductPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).sharedPref,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SharedPreferenceHomePage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).apiCallingWithPagination,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DemoPageApiScreen()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).stateManagement,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StateManagementOptionPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).geoLocation,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GoogleMapPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).inAppPurchase,
                  function: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PaymentPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).staticNotification,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationOptionPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).qrCodeScanner,
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrCodeScannerPage()));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: S.of(context).chatApplication,
                  function: () async {
                    var isGoogleUser = await checkGoogleUser();
                    isGoogleUser!= null
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatHomePage()))
                        : showAlertDialog(context);
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: width * 0.09, top: height * 0.02),
              child: commonMaterialButton(
                  text: 'Real time Database',
                  function: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RealTimeHomePage()));
                  }),
            ),
          ),
          commonHeightBox(heightBox: 30)
        ],
      ),
    );
  }

  checkGoogleUser() async {
    final querySnapshot =
    await FirebaseFirestore.instance.collection('user').get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    final userList = docs.map((doc) => UserData.fromMap(doc.data())).toList();
    UserData isUser = userList.firstWhere(
            (value) => value.userID == currentUid,
        orElse: () => null);
    return isUser;
    }
  }

  showAlertDialog(context) {
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
      title: Text("Hello User!!",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorResource.themeColor
      ),),
      content: Text(
        'For chat application google sign in is required...\n\n'
            'so you want sign in with google ??',
        style: TextStyle(
          fontSize: 13,
          color: ColorResource.themeColor
        ),
      ),
      actions: [yesButton, cancelButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
}
