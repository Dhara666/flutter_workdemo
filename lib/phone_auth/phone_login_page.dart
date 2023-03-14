import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sheet_demo/common_widget/common_button.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/phone_auth/otp_page.dart';
import 'package:sheet_demo/utils/size_utils.dart';
import 'package:sheet_demo/utils/validation.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          height: height * 0.35,
          margin: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.1),
          decoration: BoxDecoration(
              color: ColorResource.themeColor,
              borderRadius: BorderRadius.circular(10)),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Enter Your Phone Number',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: ColorResource.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: TextFormField(
                  cursorColor: ColorResource.lightThemeColor,
                  style: TextStyle(color: ColorResource.white),
                  decoration: InputDecoration(
                    hintText: ' Phone Number',
                    hintStyle: TextStyle(color: ColorResource.lightThemeColor),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorResource.white)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorResource.lightThemeColor)),
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        '+91',
                        style: TextStyle(
                            color: ColorResource.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  controller: phoneController,
                  validator: (val) => validatePhone(val, context),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                child: commonMaterialButton(
                    text: 'Next',
                    function: () {
                      if (formKey.currentState.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                OTPPage(phone: "+91 ${phoneController.text}")));
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
