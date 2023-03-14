import 'package:flutter/material.dart';
import 'package:sheet_demo/constant/color_constant.dart';
import 'package:sheet_demo/utils/size_utils.dart';

Widget commonText({String text, Color color}) {
  return Padding(
    padding: EdgeInsets.only(left: width * 0.022, bottom: 5),
    child: Container(
      child: Text(
        text,
        style: TextStyle(color: color, letterSpacing: 1),
      ),
    ),
  );
}

Widget commonHeightBox({double heightBox}) {
  return SizedBox(
    height: heightBox,
  );
}

commonSharedText({String text}) {
  return Padding(
    padding: EdgeInsets.only(left: width * 0.035),
    child: Container(
      margin: EdgeInsets.all(7),
      child: Text(
        text,
        style: TextStyle(color:  ColorResource.white, fontSize: 15),
      ),
    ),
  );
}
