import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/string_constant.dart';

String validatePassword(String value) {
  if (value.length < 8)
    return ErrorString.errorPassword;
  else
    return null;
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value))
    return ErrorString.errorEmail;
  else
    return null;
}

String validatePhone(String value, BuildContext context) {
  if (value.length < 10)
    return ErrorString.errorPhone;
  else
    return null;
}

String validateName(String value, BuildContext context) {
  if (value.length < 3)
    return ErrorString.errorName;
  else
    return null;
}

String validatePrefName(String value, BuildContext context) {
  if (value.length < 1)
    return ErrorString.errorName;
  else
    return null;
}

String validatePrefDate(String value, BuildContext context) {
  if (value.length < 1)
    return ErrorString.errorDate;
  else
    return null;
}

String validatePrefNo(String value, BuildContext context) {
  if (value.length < 1)
    return ErrorString.errorNo;
  else
    return null;
}

String validatePrice(String value, BuildContext context) {
  Pattern pattern = ("^([0-9]{0,2}((.)[0-9]{0,2}))");
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value))
    return ErrorString.errorPrice;
  else
    return null;
}

String validateDiscount(String value, BuildContext context) {
  Pattern pattern = ('([0-9]+(\.[0-9]+)?)');
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value))
    return ErrorString.errorDiscount;
  else
    return null;
}

String validateTax(String value, BuildContext context) {
  Pattern pattern = ('([0-9]+(\.[0-9]+)?)');
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value))
    return ErrorString.errorTax;
  else
    return null;
}
