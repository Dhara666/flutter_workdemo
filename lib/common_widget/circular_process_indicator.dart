import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';

Widget commonIndicator(){
  return CircularProgressIndicator(
    backgroundColor: Color(0xffc79ebc),
    valueColor: AlwaysStoppedAnimation<Color>(ColorResource.themeColor),
  );
}