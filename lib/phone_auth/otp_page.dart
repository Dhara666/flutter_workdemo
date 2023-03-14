import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sheet_demo/common_widget/common_appbar.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/pages/mainPage.dart';
import 'package:sheet_demo/pages/shared_preference/shared_preference.dart';

class OTPPage extends StatefulWidget {
  final String phone;

  OTPPage({this.phone});

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: ColorResource.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: ColorResource.themeColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    print("phone--> ${widget.phone}");
    return Scaffold(
      key: _scaffoldKey,
      appBar: commonAppbar(text: 'OTP Verification'),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify ${widget.phone}',
                style: TextStyle(fontSize: 16, color: ColorResource.themeColor),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: PinPut(
              fieldsCount: 6,
              textStyle:
                  TextStyle(fontSize: 25.0, color: ColorResource.themeColor),
              eachFieldWidth: 20.0,
              eachFieldHeight: 40.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              withCursor: true,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration,
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onSubmit: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('invalid OTP')));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
    await setPrefBoolValue(is_logIn, true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
