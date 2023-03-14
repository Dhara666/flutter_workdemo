import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sheet_demo/common_widget/account_page_common_row.dart';
import 'package:sheet_demo/common_widget/circular_process_indicator.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/generated/l10n.dart';
import 'package:sheet_demo/pages/mainPage.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/sign_in_page.dart';
import 'package:sheet_demo/services/auth_services.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:sheet_demo/utils/validation.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool pass = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: formKey,
            child: ListView(children: [
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: height * 0.2, horizontal: width * 0.05),
                height: MediaQuery.of(context).size.height * 0.57,
                decoration: BoxDecoration(
                    color:  ColorResource.themeColor, borderRadius: BorderRadius.circular(18)),
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
                          hintStyle: TextStyle(color: ColorResource.white, fontSize: 15),
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
                            hintStyle: TextStyle(color: ColorResource.white, fontSize: 15),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: ColorResource.white,
                              //color: Colors.red,
                            ),
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
                          text: S.of(context).signUp,
                          function: () async {
                            if (formKey.currentState.validate()) {
                              EasyLoading.show(indicator: commonIndicator());
                              try {
                                await AuthService().authCreateUser(
                                    emailInput: emailController.text,
                                    passwordInput: passwordController.text,
                                    context: context);
                                await setPrefBoolValue(is_logIn, true);
                                EasyLoading.dismiss();
                                print(
                                    'Sign Up Account --> ${emailController.text}');
                                Toast.show(
                                    S.of(context).signOutSuccessFully, context,
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
                    SizedBox(
                      height: 40,
                    ),
                    commonAccountRow(
                        buttonText: S.of(context).signIn,
                        text: S.of(context).alreadyHAveAnAccount,
                        function: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInPage()));
                        }),
                  ],
                ),
              )
            ])));
  }
}
