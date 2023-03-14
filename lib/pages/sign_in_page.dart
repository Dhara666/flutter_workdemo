import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sheet_demo/common_widget/account_page_common_row.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/model/user_data_model.dart';
import 'package:sheet_demo/pages/mainPage.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/sign_up_page.dart';
import 'package:sheet_demo/phone_auth/phone_login_page.dart';
import 'package:sheet_demo/services/auth_services.dart';
import 'package:sheet_demo/services/user_services.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:sheet_demo/utils/validation.dart';
import 'package:toast/toast.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  bool pass = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService authServices = AuthService();
  UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    size(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.06),
                height: Platform.isIOS
                    ? MediaQuery.of(context).size.height * 0.85
                    : MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                    color: ColorResource.themeColor,
                    borderRadius: BorderRadius.circular(18)),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.07,
                        bottom: height * 0.03,
                        right: width * 0.03,
                        left: width * 0.03,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorResource.white),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => validateEmail(val),
                        decoration: InputDecoration(
                          hintText: S.of(context).email,
                          hintStyle: TextStyle(
                              color: ColorResource.white, fontSize: 15),
                          focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: ColorResource.white)),
                          prefixIcon: Icon(
                            Icons.mail,
                            color: ColorResource.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.0,
                        bottom: height * 0.03,
                        right: width * 0.03,
                        left: width * 0.03,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: ColorResource.white),
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) => validatePassword(val),
                        obscureText: pass,
                        decoration: InputDecoration(
                            hintText: S.of(context).passWord,
                            hintStyle: TextStyle(
                                color: ColorResource.white, fontSize: 15),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: ColorResource.white,
                              //color: Colors.red,
                            ),
                            // enabledBorder:
                            //     UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorResource.white)),
                            suffixIcon: IconButton(
                                color: ColorResource.white,
                                onPressed: () {
                                  setState(() {
                                    pass = !pass;
                                  });
                                },
                                icon: pass == true
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off))),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: width * 0.12, vertical: height * 0.02),
                      child: commonMaterialButton(
                          text: S.of(context).signIn,
                          function: () async {
                            if (formKey.currentState.validate()) {
                              EasyLoading.show(indicator: commonIndicator());
                              try {
                                await AuthService().authSignInUser(
                                    emailInput: emailController.text,
                                    passwordInput: passwordController.text,
                                    context: context);
                                await getPrefStringValue(user_email);
                                await setPrefBoolValue(is_logIn, true);
                                EasyLoading.dismiss();
                                print(
                                    'Sign in Account --> ${emailController.text}');
                                Toast.show(
                                    S.of(context).signInSuccessFully, context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 5);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MainPage(
                                              email: emailController.text,
                                            )));
                              } catch (e) {
                                Toast.show(e.toString(), context,
                                    backgroundColor: ColorResource.themeColor,
                                    textColor: ColorResource.white,
                                    duration: 7);
                                EasyLoading.dismiss();
                              }
                            }
                          }),
                    ),
                    commonAccountButton(
                      text: S.of(context).signInWithGoogle,
                      image: 'assets/images/ggl.png',
                      function: signInWithGoogle,
                    ),
                    commonAccountButton(
                      text: S.of(context).signInWithPhone,
                      image: 'assets/images/phone.png',
                      function: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneLoginPage()));
                      },
                    ),
                    commonAccountButton(
                      text: S.of(context).signInWithFacebook,
                      image: 'assets/images/facebook.png',
                      function: () async {
                        try {
                          EasyLoading.show(indicator: commonIndicator());
                          await AuthService().signWithFaceBook(context);
                          await setPrefBoolValue(is_logIn, true);
                          EasyLoading.dismiss();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MainPage(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      )));
                          Toast.show(S.of(context).signInSuccessFully, context,
                              backgroundColor: ColorResource.themeColor,
                              textColor: ColorResource.white,
                              duration: 7);
                        } catch (e) {
                          Toast.show(e.toString(), context,
                              backgroundColor: ColorResource.white,
                              textColor: ColorResource.themeColor,
                              duration: 10);
                        }
                      },
                    ),
                    // commonAccountButton(
                    //   text: 'Sign in with Phone',
                    //   function: (){
                    //    Navigator.push(context, MaterialPageRoute(builder: (context)=>PhoneLoginPage()));
                    //   }
                    // ),
                    Platform.isIOS
                        ? commonAccountButton(
                            text: S.of(context).signInWithApple,
                            image: 'assets/images/apple.png',
                            function: () {})
                        : Container(),
                    SizedBox(
                      height: 25,
                    ),
                    commonAccountRow(
                        buttonText: S.of(context).signUp,
                        text: S.of(context).doNotHaveAnAccount,
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    EasyLoading.show(indicator: commonIndicator());
    var authResult = await authServices.signInWithGoogle(context);
    if (authResult != null) {
      String googleUserId = authResult.user.uid.toString();
      print('Google Created User User Id : $googleUserId');
      print('Current GOOGLE USER : ${authResult.additionalUserInfo.profile}');
      String token = await FirebaseMessaging.instance.getToken();
      print('Token Value : $token');
      UserData userDetails = UserData(
        email: authResult.additionalUserInfo.profile['email'],
        lastName: authResult.additionalUserInfo.profile['family_name'],
        firstName: authResult.additionalUserInfo.profile['given_name'],
        userID: authResult.user.uid,
        photoUrl: authResult.additionalUserInfo.profile['picture'],
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        token: token,
      );
      await userServices.createUser(userDetails);
      await setPrefBoolValue(is_logIn, true);
      EasyLoading.dismiss();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainPage(
            email: authResult.additionalUserInfo.profile['email'],
          ),
        ),
      );
      print(
          'Sign in Google Account --> ${authResult.additionalUserInfo.profile['email']}');
      Toast.show(S.of(context).signInSuccessFully, context,
          backgroundColor: ColorResource.themeColor,
          textColor: ColorResource.white,
          duration: 7);
    }
  }
}
