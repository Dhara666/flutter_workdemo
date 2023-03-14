import 'package:flutter/material.dart';
import 'package:sheet_demo/pages/mainPage.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';
import 'package:sheet_demo/pages/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    checkLogIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('Current Screen --> $runtimeType');
    return Scaffold(body: Container());
  }

  void checkLogIn() async {
    bool isLogin = await getPrefBoolValue(is_logIn);
    print('isLogin --> $isLogin');
    if (isLogin != null && isLogin) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
   else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneLoginPage()));
   }
  }
}
